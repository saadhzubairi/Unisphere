import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/model/message.dart';
import 'package:unione/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final ChatUser chatUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(0, 31, 0, 0),
          child: InkWell(
            onTap: () => null,
            splashColor: Theme.of(context).colorScheme.primary,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    width: 35,
                    height: 35,
                    imageUrl: widget.chatUser.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatUser.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      "Last Seen N/A",
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        foregroundColor: Colors.grey.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 35),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      print("[+] DATA:: ${jsonEncode(data![0].data())} ");
                      _list.clear();
                      _list.add(Message(
                          toId: "toId",
                          msg:
                              "In publishing and graphic design, Lorem ipsum is a text commonly used to demonstrate the visual form of a document",
                          read: "read",
                          type: Type.text,
                          sent: "123",
                          fromId: "fromId"));
                      _list.add(Message(
                          toId: "toId",
                          msg: "fucking  😭😭😭",
                          read: "read",
                          type: Type.text,
                          sent: "123",
                          fromId: "jukh2Q6iohOFhmbKE0hcvvNA1z22"));
                      _list.add(Message(
                          toId: "toId",
                          msg: "msg3",
                          read: "read",
                          type: Type.text,
                          sent: "123",
                          fromId: "fromId"));
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, i) {
                            return MessageCard(message: _list[i]);
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Say Hi! 👋🏻",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
            /* SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom == 0 ? 40 : 12,
            ) */
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            minLines: 1,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiary,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.transparent)),
              hintText: 'Enter a message',
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        CircleAvatar(
          radius: 23,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
