import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/Pages/dashboard.dart';

import 'package:hello2/Pages/zoomprofile.dart';
import 'package:hello2/authentication/googlesignin.dart';
import 'package:hello2/authentication/login1.dart';

import 'package:hello2/helper/api.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/profilestarter.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  // final usermodel? userModel;
  final User? firebaseuser;

  const ProfileScreen(
      {super.key, required this.user, required this.firebaseuser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Name Loading..";
  String email = "Email Loading..";

  void getdata() {
    // var firestore = await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(widget.firebaseuser!.uid)
    //     .get();

    setState(() {
      name = widget.user.name;
      email = widget.user.email;
    });
  }

  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseuser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          mymodel: widget.user,
                          firebaseuser: widget.firebaseuser,
                        )));
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color.fromARGB(255, 58, 9, 9)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.image),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .1),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.height * .2,
                    height: MediaQuery.of(context).size.height * .2,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(email)

                // StreamBuilder<QuerySnapshot>(
                //   stream: firestore,
                //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if(snapshot.connectionState == ConnectionState.waiting)
                //     return CircularProgressIndicator();
                //     if(snapshot.hasError)
                //     return Text("Error to load");
                //     if(snapshot.hasData)
                //     return ListView.builder(itemBuilder: itemBuilder)

                //   })
              ],
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Edit profile',
                onTap: (() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return ProfileStarter(
                      user: widget.user,
                      // userModel: widget.userModel,
                      firebaseuser: widget.firebaseuser,
                    );
                  }));
                })),
            SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: (() {}),
              title: Text("Settings"),
              leading: Icon(Icons.settings_applications),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: (() {}),
              title: Text("Payment"),
              leading: Icon(Icons.wallet),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: (() {}),
              title: Text("Feedback"),
              leading: Icon(Icons.feedback),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: (() {}),
              title: Text("Details"),
              leading: Icon(Icons.info_outline),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: (() async {
                await FirebaseServices().signout();
                // Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              }),
              title: Text("Log Out"),
              leading: Icon(Icons.logout_sharp),
            )
          ],
        ),
      )),
    );
  }
}
