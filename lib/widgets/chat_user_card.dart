import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unione/model/chat_user.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.1,
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatScreen(
                      chatUser: widget.user,
                    )));
          },
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: widget.user.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
            title: Text(widget.user.name,
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(widget.user.about,
                maxLines: 1, style: Theme.of(context).textTheme.labelMedium),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    height: 10,
                    width: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "12:00",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
