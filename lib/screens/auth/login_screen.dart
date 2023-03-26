import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/screens/home_screen.dart';
import '../../utils/theme_state.dart';
import '../../utils/dialogs.dart';
import '../../widgets/icon_w_background.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  void _handleGoogleSignInButton() {
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        print('User: ${user.user}');
        print('UserInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          APIs.createUser().then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen())));
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("signInWithGoogle $e");
      Dialogs.showSnackbar(context, "No internet connection, try again");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UNISPHERE",
          style: GoogleFonts.lato(fontWeight: FontWeight.w900),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconWBackground(
                icon: Icons.dark_mode,
                onTap: () {
                  Provider.of<ThemeState>(context, listen: false).toggleTheme();
                }),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          left: _isAnimate
              ? MediaQuery.of(context).size.width * 0.25
              : -MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset('assets/images/letter-u.png'),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.065,
          width: MediaQuery.of(context).size.width * 1,
          child: Text(
            "©Unisphere Technologies LLC. 2023. All rights reserved.",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(fontSize: 10),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.38,
          left: MediaQuery.of(context).size.width * 0,
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              "Breaking Ice, And Beyond!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.14,
          left: MediaQuery.of(context).size.width * 0.12,
          width: MediaQuery.of(context).size.width * 0.75,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.background),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onBackground),
              splashFactory: InkRipple.splashFactory,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              elevation: MaterialStateProperty.all(15),
            ),
            onPressed: () {
              _handleGoogleSignInButton();
            },
            icon: SizedBox(
              height: 35,
              child: Image.asset('assets/images/google.png'),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
              child: Text(
                "Sign in with Google",
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
