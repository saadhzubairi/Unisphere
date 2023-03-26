import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/screens/auth/login_screen.dart';
import 'package:unione/screens/home_screen.dart';
import '../../utils/theme_state.dart';
import '../../widgets/icon_w_background.dart';
import '../api/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_controller);

    _sizeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_controller);

    _controller.forward();

    setState(() {});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LoginAuthScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: MediaQuery.of(context).size.width * 0.25,
          child: AnimatedOpacity(
            opacity: _opacityAnimation.value,
            duration: const Duration(milliseconds: 500),
            child: AnimatedContainer(
              width: _sizeAnimation.value *
                  MediaQuery.of(context).size.width *
                  0.5,
              height: _sizeAnimation.value *
                  MediaQuery.of(context).size.width *
                  0.5,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Image.asset('assets/images/letter-u.png'),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 1,
          child: Text(
            "©Unisphere Technologies LLC. 2023. All rights reserved.",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(fontSize: 10),
          ),
        ),
        //motto
        Positioned(
          top: MediaQuery.of(context).size.height * 0.48,
          left: MediaQuery.of(context).size.width * 0,
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              "UNISPHERE",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.75,
          left: MediaQuery.of(context).size.width * 0,
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 170),
            child: IconWBackground(
              icon: Icons.dark_mode,
              onTap: () {
                Provider.of<ThemeState>(context, listen: false).toggleTheme();
              },
            ),
          ),
        ),
      ]),
    );
  }
}
