import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/message.dart';
import 'package:unione/screens/view_chat_image.dart';
import 'package:unione/screens/view_profile_image.dart';
import 'package:unione/utils/date_time_util.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final String name;
  const MessageCard({super.key, required this.message, required this.name});
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.cUser.uid == widget.message.fromId
        ? _blueMessage()
        : _greyMessage();
  }

  Widget _blueMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 315),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.message.type == Type.text
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                          child: Text(
                            widget.message.msg,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) => ViewChatImage(
                                            imgUrl: widget.message.msg,
                                            time: widget.message.sent,
                                            username: "You",
                                          ))),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 300,
                                height: 300,
                                imageUrl: widget.message.msg,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                        Icons.image_not_supported_outlined),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateUtil.getFormattedTime(
                              context, widget.message.sent),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        widget.message.read.isEmpty
                            ? Icon(Icons.done_rounded,
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant)
                            : Icon(Icons.done_all_rounded,
                                size: 18, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greyMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print("read updated of '${widget.message.msg}'");
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 315),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.message.type == Type.text
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                          child: Text(
                            widget.message.msg,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(0),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) => ViewChatImage(
                                            imgUrl: widget.message.msg,
                                            time: widget.message.sent,
                                            username: widget.name,
                                          ))),
                              child: CachedNetworkImage(
                                width: 300,
                                height: 300,
                                imageUrl: widget.message.msg,
                                placeholder: (context, url) => Center(
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                        Icons.image_not_supported_outlined),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 12),
                    child: Text(
                      DateUtil.getFormattedTime(context, widget.message.sent),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
