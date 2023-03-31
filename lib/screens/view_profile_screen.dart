import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/screens/view_profile_image.dart';
import 'package:unione/utils/date_time_util.dart';
import 'package:unione/utils/dialogs.dart';

import '../utils/theme_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_w_background.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class ViewProfileScreen extends StatefulWidget {
  final ChatUser cUser;
  const ViewProfileScreen({super.key, required this.cUser});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _img;
  File? _imgFile;

  late AppState state;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconWBackground(
                  icon: Icons.dark_mode,
                  onTap: () {
                    Provider.of<ThemeState>(context, listen: false)
                        .toggleTheme();
                  }),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                  ),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (builder) => ViewProfileImage(
                                    imgUrl: widget.cUser.image))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Hero(
                            tag: 'image',
                            child: CachedNetworkImage(
                              width: 240,
                              height: 240,
                              fit: BoxFit.fill,
                              imageUrl: widget.cUser.image,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    widget.cUser.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 70),
                  Text(
                    widget.cUser.email,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 70),
                  Text(
                    widget.cUser.about,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.cUser.isOnline
                        ? "Online"
                        : DateUtil.getLastActiveTime(
                            context: context,
                            lastActive: widget.cUser.lastActive),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
