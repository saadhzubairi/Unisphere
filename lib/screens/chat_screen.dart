import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/model/message.dart';
import 'package:unione/screens/view_profile_screen.dart';
import 'package:unione/utils/date_time_util.dart';
import 'package:unione/widgets/message_card.dart';

import '../utils/dialogs.dart';
import '../utils/theme_state.dart';
import '../widgets/icon_w_background.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatUser});
  final ChatUser chatUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
          systemNavigationBarColor: Theme.of(context).colorScheme.shadow,
        ),
      ),
    );
  }

  List<Message> _list = [];

  final _controller = TextEditingController();

  bool isUploading = false;

  bool _themed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ViewProfileScreen(cUser: widget.chatUser))),
              splashColor: Theme.of(context).colorScheme.primary,
              child: StreamBuilder(
                stream: APIs.getUserInfo(widget.chatUser),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  return Row(
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
                        child: Hero(
                          tag: 'image',
                          child: CachedNetworkImage(
                            width: 35,
                            height: 35,
                            imageUrl: list!.isNotEmpty
                                ? list[0].image
                                : widget.chatUser.image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          ),
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
                            list!.isNotEmpty
                                ? list[0].name
                                : widget.chatUser.name,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            list!.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : DateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: list[0].lastActive)
                                : DateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.chatUser.lastActive),
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ],
                  );
                },
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

                  Future.delayed(Duration(milliseconds: 100)).then(
                    (value) => SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle(
                        statusBarBrightness: Theme.of(context).brightness,
                        statusBarColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        systemNavigationBarColor:
                            Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
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
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                  name: widget.chatUser.name,
                                );
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
              if (isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 30),
                    child: CircularProgressIndicator(),
                  ),
                ),
              _chatInput(),
              /* SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom == 0 ? 40 : 12,
              ) */
            ],
          ),
        ),
      ),
    );
  }

  String? _img;
  File? _imgFile;

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
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _img = image.path;
                      });
                      _cropImage().then((value) {
                        if (_imgFile != null) {
                          isUploading = true;
                          APIs.sendChatImage(widget.chatUser, _imgFile!)
                              .then((value) {
                            setState(() {
                              isUploading = false;
                            });
                          });
                          _imgFile = null;
                        }
                      });
                    } else {
                      Dialogs.showThemedSnackbar(context, "Error Occured");
                    }
                  },
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
                APIs.sendMessage(widget.chatUser, _controller.text, Type.text);
                _controller.text = '';
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _cropImage() async {
    if (File(_img!) != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: File(_img!).path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Selected Image',
            toolbarColor: Colors.black,
            cropGridColumnCount: 2,
            cropGridRowCount: 2,
            cropFrameStrokeWidth: 10,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            hideBottomControls: false,
            showCropGrid: true,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _imgFile = File(croppedFile.path);
        });
      }
    }
  }
}
