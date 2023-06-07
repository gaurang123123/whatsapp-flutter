import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'package:hello2/Pages/dashboard.dart';

import 'package:hello2/authentication/googlesignin.dart';
import 'package:hello2/authentication/login1.dart';
import 'package:hello2/helper/helper.dart';

import 'package:hello2/models/chatuser.dart';

import 'package:hello2/pages/Profilescreen.dart';

class Home extends StatefulWidget {
  final ChatUser mymodel;
  final User? firebaseuser;

  const Home({
    super.key,
    required this.mymodel,
    required this.firebaseuser,
  });

  // const Home({super.key,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
      menuScreen: DrawerScreen(
        firebaseuser: widget.firebaseuser,
        mymodel: widget.mymodel,
        setIndex: (index) {
          setState(() {
            currentIndex = index;
            // ZoomDrawer.of(context)!.toggle();
          });
        },
      ),
      mainScreen: currentScreen(),
      borderRadius: 20,
      showShadow: true,
      angle: -10.0,
      slideWidth: 250,
      menuBackgroundColor: Colors.deepPurple,
      // set slideWidth
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return Dashboard(
          mymodel: widget.mymodel,
          firebaseuser: widget.firebaseuser,
        );
      case 1:
        return ProfileScreen(
          user: widget.mymodel,
          firebaseuser: widget.firebaseuser,
        );
      case 2:
        return HomeScreen(
          title: "Sent",
        );
      case 3:
        return HomeScreen(
          title: "Favorite",
        );
      case 4:
        return HomeScreen(
          title: "Archive",
        );
      case 5:
        return HomeScreen(
          title: "Spam",
        );
      default:
        return HomeScreen();
    }
  }
}

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: DrawerWidget(),
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  final ChatUser? mymodel;
  final User? firebaseuser;
  final ValueSetter setIndex;
  const DrawerScreen(
      {Key? key,
      required this.setIndex,
      required this.firebaseuser,
      required this.mymodel})
      : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String name = "Name Loading..";
  String email = "Email Loading..";
  // String ProfilePic1 = "Loading..";

  // void getdata() async {
  //   // var firestore = await FirebaseFirestore.instance
  //   //     .collection('user')
  //   //     .doc(widget.firebaseuser!.uid)
  //   //     .get();

  //   setState(() {
  //     name = api.me.name.toString();
  //     email = api.me.email.toString();
  //     log(name.toString());
  //   });
  // }

  // @override
  // void initState() {
  //   getdata();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CupertinoButton(
              //   onPressed: () {},
              // child: CircleAvatar(
              //   radius: 60,
              //   backgroundColor: Colors.grey,
              //   backgroundImage:
              //       (ProfilePic1 != null) ? NetworkImage(ProfilePic1) : null,
              //   child: (widget.userModel!.Profilepic == null)
              //       ? const Icon(
              //           Icons.person,
              //           size: 60,
              //         )
              //       : null,
              // ),
              // ),
              SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .1),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.height * .16,
                  height: MediaQuery.of(context).size.height * .16,
                  fit: BoxFit.fill,
                  imageUrl: widget.mymodel!.image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                width: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    widget.mymodel!.name,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.mymodel!.email,
                    // api.me.email,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: 70,
              ),
              drawerList(Icons.dashboard, "Dashboard", 0),
              SizedBox(
                height: 20,
              ),
              drawerList(Icons.person, "Profile", 1),
              SizedBox(
                height: 20,
              ),
              drawerList(Icons.payment, "Payment", 2),
              SizedBox(
                height: 20,
              ),
              drawerList(Icons.favorite, "Rate Us", 3),
              SizedBox(
                height: 20,
              ),
              drawerList(Icons.info, "About Us", 4),
              SizedBox(
                height: 20,
              ),
              drawerList(Icons.settings, "Settings", 5),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: 40, width: 300),
                    child: ElevatedButton.icon(
                      onPressed: (() async {
                        helper
                            .updateActiveStatus(false, widget.mymodel)
                            .then((value) {});
                        await FirebaseServices().signout();
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      }),
                      icon: Icon(Icons.logout),
                      label: Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 18, 15, 162),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          elevation: 15,
                          shadowColor: Colors.blue,
                          side: BorderSide(color: Colors.black, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.setIndex(index);
        ZoomDrawer.of(context)!.close();

        // ZoomDrawer.of(context)!.toggle();
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, bottom: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: Icon(Icons.menu),
    );
  }
}
