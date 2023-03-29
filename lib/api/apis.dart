import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unione/model/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get cUser => auth.currentUser!;

  //for storing self info:
  static late ChatUser me;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(cUser.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    return await firestore
        .collection('users')
        .doc(cUser.uid)
        .get()
        .then((user) => {
              if (user.exists)
                {me = ChatUser.fromJson(user.data()!)}
              else
                {createUser().then((value) => getSelfInfo())}
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

    return await firestore
        .collection('users')
        .doc(cUser.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where("id", isNotEqualTo: cUser.uid)
        .snapshots();
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
    await firestore
        .collection('users')
        .doc(cUser.uid)
        .update({'image': me.image});
  }

  /*CHAT SCREEN STUFF*/

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore.collection('messages').snapshots();
  }
}
