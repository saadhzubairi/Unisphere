import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/utils/dialogs.dart';

import '../utils/theme_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_w_background.dart';
import 'auth/login_screen.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class UserScreen extends StatefulWidget {
  final ChatUser cUser;

  const UserScreen({super.key, required this.cUser});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
    _signOut() async {
      APIs.updateActiveStatus(false);
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut().then(
        (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginAuthScreen(),
            ),
          );
          APIs.auth = FirebaseAuth.instance;
        },
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "USER INFO",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconWBackground(
                  icon: Icons.logout, onTap: () => APIs.updateActiveStatus(false).then((value) => _signOut())),
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
                      _imgFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                _imgFile!,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                width: 140,
                                height: 140,
                                fit: BoxFit.fill,
                                imageUrl: widget.cUser.image,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.person),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: -25,
                        child: MaterialButton(
                          onPressed: () {
                            _showModalSheet();
                          },
                          shape: CircleBorder(),
                          color: Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  Text(
                    widget.cUser.email,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    prompText: "Username",
                    initialValue: widget.cUser.name,
                    hintText: "Eg: Julias Ceaser",
                    prefixIcon: const Icon(Icons.person),
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    prompText: "About",
                    initialValue: widget.cUser.about,
                    hintText: "Eg: Feeling Great 🥲",
                    prefixIcon: const Icon(Icons.info),
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.done_all_sharp),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print("inside validator");
                        APIs.updateUserInfo().then((value) => Dialogs.showThemedSnackbar(context, "Updated User Info"));
                      }
                    },
                    label: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModalSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Pick Profile Picture",
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _img = image.path;
                        });
                        _cropImage().then((value) {
                          APIs.updateProfilePicture(_imgFile!);
                          Navigator.pop(context);
                          Dialogs.showThemedSnackbar(context, "Profile Picture Updated");
                        });
                      } else {
                        Dialogs.showSnackbar(context, "Error Occured");
                      }
                    },
                    icon: Icon(Icons.photo),
                    label: Text("Gallery"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(100, 40)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _img = image.path;
                        });
                        APIs.updateProfilePicture(File(_img!));
                        Navigator.pop(context);
                      }
                      Dialogs.showThemedSnackbar(context, "Profile Picture Updated");
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(100, 40)),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
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
            lockAspectRatio: true,
            hideBottomControls: true,
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
            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
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
