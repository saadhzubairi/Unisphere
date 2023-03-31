import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/screens/auth/login_screen.dart';
import 'package:unione/screens/chat_screen.dart';
import 'package:unione/screens/user_screen.dart';
import 'package:unione/widgets/chat_user_card.dart';
import '../widgets/icon_w_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut().then(
          (value) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginAuthScreen(),
              ),
            ),
            APIs.auth = FirebaseAuth.instance,
            APIs.updateActiveStatus(false),
          },
        );
  }

  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
          systemNavigationBarColor: Theme.of(context).colorScheme.shadow,
        ),
      ),
    );
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('inactive')) {
          APIs.updateActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _isSearching = false;
      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.shadow,
          appBar: AppBar(
            title: _isSearching
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name or Email..."),
                      style: Theme.of(context).textTheme.bodyMedium,
                      autofocus: true,
                      onChanged: (val) {
                        //search logic:
                        _searchList.clear();
                        for (var i in list) {
                          if ((i.name
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) &&
                              val.isNotEmpty) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    ),
                  )
                : Text(
                    "UNISPHERE",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w900),
                  ),
            leading: Align(
              alignment: Alignment.centerRight,
              child: IconWBackground(
                  icon: Icons.person,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserScreen(
                                  cUser: APIs.me,
                                )));
                  }),
            ),
            actions: [
              Align(
                alignment: Alignment.centerRight,
                child: IconWBackground(
                    icon: _isSearching ? Icons.clear_rounded : Icons.search,
                    onTap: () {
                      _searchList.clear();
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    }),
              ),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.centerRight,
                child: IconWBackground(
                    icon: Icons.logout,
                    onTap: () => APIs.updateActiveStatus(false)
                        .then((value) => _signOut())),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                ///asdasdasd
                list.clear();
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs;
                  for (var i in data!) {
                    list.add(ChatUser.fromJson(i.data()));
                  }
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _isSearching ? _searchList.length : list.length,
                  itemBuilder: (context, i) {
                    return ChatUserCard(
                      user: _isSearching ? _searchList[i] : list[i],
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {}, child: const Icon(Icons.textsms)),
        ),
      ),
    );
  }
}
