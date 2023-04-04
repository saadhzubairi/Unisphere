import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unione/api/apis.dart';
import 'package:unione/model/chat_user.dart';
import 'package:unione/screens/auth/login_screen.dart';
import 'package:unione/screens/user_screen.dart';
import 'package:unione/widgets/chat_user_card.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_w_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    Future.delayed(Duration(milliseconds: 1)).then(
      (value) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            /* statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
          systemNavigationBarIconBrightness: Theme.of(context).brightness,
          systemNavigationBarColor: Theme.of(context).colorScheme.shadow, */
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
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "Name or Email..."),
                      style: Theme.of(context).textTheme.bodyMedium,
                      autofocus: true,
                      onChanged: (val) {
                        //search logic:
                        _searchList.clear();
                        for (var i in list) {
                          if ((i.name.toLowerCase().contains(val.toLowerCase()) ||
                                  i.email.toLowerCase().contains(val.toLowerCase())) &&
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
                    icon: Icons.logout, onTap: () => APIs.updateActiveStatus(false).then((value) => _signOut())),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder(
                stream: APIs.getMyFriends(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.map((e) => e.id).toList().length > 1) {
                      return StreamBuilder(
                        stream: APIs.getAllUsers(snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                        builder: (context, snapshot) {
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
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Theme.of(context).textTheme.displayMedium?.color,
                            size: MediaQuery.of(context).size.width * .15,
                          ),
                          Center(
                            child: Text(
                              "Add New Friends!",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                }),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showSearchUserDialoge();
              },
              child: const Icon(Icons.textsms)),
        ),
      ),
    );
  }

  void _showSearchUserDialoge() {
    String email = "";
    showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.all(100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Theme.of(context).colorScheme.shadow,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    size: 35,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade500
                        : Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Add Friend",
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                ],
              ),
            ),
            CustomTextField(
              onChanged: (value) => email = value,
              prompText: "Email",
              hintText: "Enter email address",
              prefixIcon: const Icon(Icons.email_outlined),
              validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Color.fromARGB(255, 183, 48, 38)),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).colorScheme.error.withOpacity(0.1);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      APIs.addFriend(email);
                    },
                    child: Text("Add"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
