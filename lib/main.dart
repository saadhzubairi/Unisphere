import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:provider/provider.dart';
import 'package:unione/screens/splash_screen_animated.dart';
import 'utils/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Media Querry
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) async {
      await FlutterNotificationChannel.registerNotificationChannel(
        description: 'Message Notifications on arrival',
        id: 'chats',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        name: 'Chats',
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
        allowBubbles: true,
        enableVibration: true,
        enableSound: true,
        showBadge: true,
      ).then((value) => runApp(const MyApp()));
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeState(),
      child: Consumer<ThemeState>(
        builder: (context, themeState, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Theme Demo',
            theme: themeState.getTheme(),
            home: const SplashScreenAnimated(),
          );
        },
      ),
    );
  }
}

/* _initializeFirebase() async {
  ;
} */
