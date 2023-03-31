import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/model/message.dart';
import 'package:unione/utils/date_time_util.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? lMessage;

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
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;

                final _list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (_list.isNotEmpty) lMessage = _list[0];

                return ListTile(
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                  title: Text(widget.user.name,
                      style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: lMessage != null
                      ? Row(
                          children: [
                            lMessage!.fromId == APIs.cUser.uid
                                ? (lMessage!.read.isEmpty
                                    ? Icon(Icons.done_rounded, size: 18)
                                    : Icon(Icons.done_all_rounded, size: 18))
                                : Icon(Icons.call_received_outlined, size: 18),
                            SizedBox(
                              width: 5,
                            ),
                            lMessage!.type == Type.text
                                ?
                                //MESSAGE
                                Flexible(
                                    child: Container(
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          lMessage != null
                                              ? lMessage!.msg
                                              : widget.user.about,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium),
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Icon(Icons.image, size: 18),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text("image",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium)
                                    ],
                                  )
                          ],
                        )
                      : Text(
                          overflow: TextOverflow.ellipsis,
                          widget.user.about,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelMedium),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: lMessage != null
                                  ? ((lMessage!.fromId != APIs.cUser.uid &&
                                          lMessage!.read.isEmpty)
                                      ? Colors.green
                                      : Colors.transparent)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20)),
                          height: 10,
                          width: 10,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        lMessage != null
                            ? DateUtil.getLastMessageTime(
                                context: context,
                                time: lMessage!.sent.toString())
                            : "",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}

/* 
ListTile(
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
        
 */
