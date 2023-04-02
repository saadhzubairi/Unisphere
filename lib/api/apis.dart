import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/model/message.dart';
import 'package:http/http.dart' as http;

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get cUser => auth.currentUser!;

  //for storing self info:
  static late ChatUser me = ChatUser(
      image: "image",
      name: "name",
      about: "about",
      createdAt: "createdAt",
      id: "id",
      lastActive: "lastActive",
      isOnline: false,
      pushToken: "pushToken",
      email: "email");

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(cUser.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(cUser.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: cUser.photoURL.toString(),
        name: cUser.displayName.toString(),
        about: "Hey!",
        createdAt: time,
        id: cUser.uid,
        lastActive: time,
        isOnline: false,
        pushToken: "pushToken",
        email: cUser.email.toString());

    return await firestore.collection('users').doc(cUser.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('users').where("id", isNotEqualTo: cUser.uid).snapshots();
  }

  static Future<void> updateUserInfo() async {
    return await firestore.collection('users').doc(cUser.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child("profile_pictures/${cUser.uid}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(cUser.uid).update({'image': me.image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUSer) {
    return firestore.collection('users').where('id', isEqualTo: chatUSer.id).snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    return firestore.collection('users').doc(cUser.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }

  //PUSH NOTIFICATIONS:
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        log("push_token: $token");
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendPushNotification(ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAESmhSWs:APA91bE4OXUuYYaN9_2xzV1vhsoyDjdZrWpM2MfAsEl78Gtm3KunVlYJWfZo3cYDYu4VbhgXY7xBv0LQ9WmQU2993UK-ksKW-UUTq1C5Nd9dbw3pIbW9sYwcBqXFaA_MiTf4RiK7qXCi'
          },
          body: jsonEncode(body));

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('sendPushNotif: ${e.toString()}');
    }
  }

  /*CHAT SCREEN STUFF*/
  //chats (collection) --> convo_id (doc) --> message (collection) --> message (doc)

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static String getConversationID(String id) =>
      cUser.uid.hashCode <= id.hashCode ? '${cUser.uid}_$id' : '${id}_${cUser.uid}';

  static Future<void> sendMessage(ChatUser user, String message, Type type) async {
    final sentTime = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send:
    final _message = Message(toId: user.id, msg: message, read: '', type: type, sent: sentTime, fromId: cUser.uid);

    final ref = firestore.collection('chats/${getConversationID(user.id)}/messages/');
    await ref
        .doc(sentTime)
        .set(_message.toJson())
        .then((value) => sendPushNotification(user, type == Type.text ? message : "Image"));
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split(".").last;
    final ref =
        storage.ref().child("images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    final imgUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imgUrl, Type.image);
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore.collection('chats/${getConversationID(message.toId)}/messages/').doc(message.sent).delete();
    if (message.type == Type.image) await storage.refFromURL(message.msg).delete();
  }

  static Future<void> updateMessageText(Message message, String updatedMsg) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
