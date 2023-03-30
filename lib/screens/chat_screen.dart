import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/model/message.dart';
import 'package:unione/widgets/message_card.dart';

import '../utils/theme_state.dart';
import '../widgets/icon_w_background.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final ChatUser chatUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
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
                  icon: Icon(Icons.arrow_back),
                ),
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
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconWBackground(
              icon: Icons.dark_mode,
              onTap: () {
                Provider.of<ThemeState>(context, listen: false).toggleTheme();
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            10, 5, 10, MediaQuery.of(context).viewInsets.bottom == 0 ? 35 : 15),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.chatUser),
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
                        _list.clear();
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            },
                          );
                        } else {
                          return const Center(
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
            controller: _controller,
            minLines: 1,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiary,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
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
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 23,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                APIs.sendMessage(widget.chatUser, _controller.text);
                _controller.text = '';
              }
            },
          ),
        ),
      ],
    );
  }
}
