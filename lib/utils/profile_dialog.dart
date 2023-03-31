import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unione/widgets/icon_w_background.dart';

import '../model/chat_user.dart';
import '../screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: MediaQuery.of(context).size.width / 2 - 175,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => ViewProfileScreen(
                              cUser: user,
                            )));
                  },
                  child: Hero(
                    tag: 'pfimage${user.id}',
                    child: CachedNetworkImage(
                      width: 200,
                      height: 200,
                      imageUrl: user.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 175,
              right: 15,
              child: IconWBackground(
                icon: Icons.info,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => ViewProfileScreen(
                            cUser: user,
                          )));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.displayMedium,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.30),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    user.about,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

/* Theme.of(context).colorScheme.background */