import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/message.dart';
import 'package:unione/screens/view_chat_image.dart';
// import 'package:unione/screens/view_profile_image.dart';
import 'package:unione/utils/date_time_util.dart';
import 'package:unione/utils/dialogs.dart';

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
    return InkWell(
      child: APIs.cUser.uid == widget.message.fromId ? _blueMessage() : _greyMessage(),
      onLongPress: () {
        _showModalSheet();
      },
    );
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
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
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
                                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
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
                          DateUtil.getFormattedTime(context, widget.message.sent),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        widget.message.read.isEmpty
                            ? Icon(Icons.done_rounded, size: 18, color: Theme.of(context).colorScheme.outlineVariant)
                            : const Icon(Icons.done_all_rounded, size: 18, color: Colors.white),
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
                            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder) => ViewChatImage(
                                        imgUrl: widget.message.msg,
                                        time: widget.message.sent,
                                        username: widget.name,
                                      ))),
                              child: CachedNetworkImage(
                                width: 300,
                                height: 300,
                                imageUrl: widget.message.msg,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
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

  bool _isDownloading = false;

  void _showModalSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (BuildContext context) {
        bool isd = false;
        return StatefulBuilder(
          builder: (BuildContext context, setState) => ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: widget.message.msg));
                          Dialogs.showThemedSnackbar(context, "Copied Successfully");
                          Navigator.of(context).pop();
                        },
                        icon: Icon(widget.message.type != Type.image ? Icons.copy : Icons.link),
                        tooltip: widget.message.type != Type.image ? "Copy Text" : "Copy Image Link"),
                    if (APIs.cUser.uid == widget.message.fromId)
                      const SizedBox(
                        width: 15,
                      ),
                    if (APIs.cUser.uid == widget.message.fromId)
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit), tooltip: "Edit text"),
                    if (APIs.cUser.uid == widget.message.fromId)
                      const SizedBox(
                        width: 15,
                      ),
                    if (APIs.cUser.uid == widget.message.fromId)
                      IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await APIs.deleteMessage(widget.message).then((value) {
                              Dialogs.showThemedSnackbar(context, "Message Deleted");
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.delete),
                          tooltip: "Delete text"),
                    const SizedBox(
                      width: 15,
                    ),
                    if (widget.message.type == Type.image)
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              _isDownloading = true;
                            });
                            try {
                              await GallerySaver.saveImage(
                                widget.message.msg,
                                albumName: "Unisphere",
                                toDcim: false,
                              ).then((success) {
                                Navigator.pop(context);
                                _isDownloading = false;
                                if (success != null && success) {
                                  Dialogs.showThemedSnackbar(context, "Image Saved To Gallery");
                                } else {
                                  Dialogs.showSnackbar(context, "Download Failed");
                                }
                              });
                            } catch (e) {
                              Dialogs.showThemedSnackbar(context, e.toString());
                            }
                          },
                          icon: _isDownloading ? CircularProgressIndicator() : Icon(Icons.download),
                          tooltip: "Download to gallery"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(37, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      const Icon(Icons.send),
                      const SizedBox(width: 15),
                      APIs.cUser.uid == widget.message.fromId
                          ? Text("Sent: ${DateUtil.getFormattedTime(context, widget.message.sent)}")
                          : Text("Recieved: ${DateUtil.getFormattedTime(context, widget.message.sent)}")
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Icon(Icons.remove_red_eye_rounded),
                      const SizedBox(width: 15),
                      widget.message.read.isEmpty
                          ? const Text("Text not read yet")
                          : Text("Read: ${DateUtil.getFormattedTime(context, widget.message.read)}")
                    ])
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        );
      },
    );
  }
}



/* showModalBottomSheet(
  context: context,
  builder: (BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        bool b = false;
        return StatefulBuilder(
          builder: (BuildContext context, setState) => Switch(onChanged: (bool v) {setState(() => b = v);},value: b,),
        );
      },
    );
  },
); */