import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello2/Pages/zoomprofile.dart';
import 'package:hello2/authentication/googlesignin.dart';
import 'package:hello2/authentication/login1.dart';

import 'package:hello2/helper/api.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/models/chatroommodel.dart';

import 'package:hello2/models/chatuser.dart';
import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/chatusercard.dart';

class Dashboard extends StatefulWidget {
  final ChatUser mymodel;
  final User? firebaseuser;
  // final usermodel? userModel;
  // final User? firebaseuser;
  // final ChatUser user;
  // ChatUser user = api.me;

  const Dashboard(
      {super.key, required this.mymodel, required this.firebaseuser});
  // const Dashboard({});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<ChatUser> list = [];
  // final search = TextEditingController();
  List<ChatUser> searchlist = [];
  // final ChatUser user = api.me;

  bool issearching = false;
  @override
  // Future<void> initState()  {
  //   // TODO: implement initState
  //   super.initState();
  //   // user = api.me;
  //   helper.getselfinfo();

  //   SystemChannels.lifecycle.setMessageHandler((message) {
  //     log(message.toString());
  //     if (message.toString().contains('resume'))
  //       helper.updateActiveStatus(true, widget.mymodel);
  //     if (message.toString().contains('pause'))
  //       helper.updateActiveStatus(false, widget.mymodel);
  //     return Future.value(message);
  //   });
  // }
  void initState() {
    // TODO: implement initState

    super.initState();
    helper.getselfinfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message.toString());
      if (helper.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          helper.updateActiveStatus(true, widget.mymodel);
        if (message.toString().contains('pause'))
          helper.updateActiveStatus(false, widget.mymodel);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (issearching) {
            setState(() {
              issearching = !issearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: issearching
                  ? TextField(
                      // controller: search,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Name,Email...'),
                      style: TextStyle(fontSize: 20, letterSpacing: 0.5),
                      autofocus: true,
                      onChanged: (value) {
                        searchlist.clear();

                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            searchlist.add(i);
                          }
                          setState(() {
                            searchlist;
                          });
                        }
                      },
                    )
                  : Text("Dashboard"),
              centerTitle: true,
              leading: DrawerWidget(),
              actions: [
                IconButton(
                    onPressed: (() {
                      setState(() {
                        issearching = !issearching;
                      });
                    }),
                    icon:
                        Icon(issearching ? CupertinoIcons.clear : Icons.search))
              ],
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isNotEqualTo: widget.firebaseuser!.uid)
                    // .where('name', isEqualTo: search.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      log("has data");
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;
                      if (datasnapshot.docs.length > 0) {
                        // log(list["participants"].toString());
                        final data = snapshot.data!.docs;
                        list = data
                            .map(
                              (e) => ChatUser.fromJson(e.data()),
                            )
                            .toList();
                        log("1");
                        log(widget.mymodel.id);
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 6),
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              issearching ? searchlist.length : list.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: issearching
                                    ? searchlist[index]
                                    : list[index],
                                me: widget.mymodel,
                                firebaseuser: widget.firebaseuser);
                            // final data = snapshot.data?.docs;
                            // var list = data!
                            //         .map(
                            //             (e) => ChatroomModel.fromJson(e.data()))
                            //         .toList() ??
                            //     [];

                            // log(list.)
                            // ChatroomModel chatroom = ChatroomModel.fromJson(
                            //     datasnapshot.docs[index].data()
                            //         as Map<String, dynamic>);
                            // log(chatroom.lastmessage.toString());
                            // log(chatroom.chatroomid.toString());
                            // log(chatroom.participants.toString());

                            // log(chatroom.participants.map((key, value) => ());
                            // Map<String, dynamic>? participants = chatroom.participants;
                            // // log(participants.keys.toString());
                            // List<String> participantskeys = participants!.keys.toList();
                            // log(list.toString());
                            // log(participantskeys.toString());
                            // log(participantskeys[0]);
                            // participantskeys.remove(widget.mymodel.id);
                            // Text(participantskeys[0].toString());
                          },
                        );
                      }
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  );
                })),
      ),
    );
    // return GestureDetector(
    //   onTap: () => FocusScope.of(context).unfocus(),
    //   child: WillPopScope(
    //     onWillPop: () {
    //       if (issearching) {
    //         setState(() {
    //           issearching = !issearching;
    //         });
    //         return Future.value(false);
    //       } else {
    //         return Future.value(true);
    //       }
    //     },
    //     child: Scaffold(
    //         appBar: AppBar(
    //           title: issearching
    //               ? TextField(
    //                   decoration: InputDecoration(
    //                       border: InputBorder.none, hintText: 'Name,Email...'),
    //                   style: TextStyle(fontSize: 20, letterSpacing: 0.5),
    //                   autofocus: true,
    //                   onChanged: (value) {
    //                     searchlist.clear();
    //                     for (var i in list) {
    //                       if (i.name
    //                               .toLowerCase()
    //                               .contains(value.toLowerCase()) ||
    //                           i.email
    //                               .toLowerCase()
    //                               .contains(value.toLowerCase())) {
    //                         searchlist.add(i);
    //                       }
    //                       setState(() {
    //                         searchlist;
    //                       });
    //                     }
    //                   },
    //                 )
    //               : Text("Dashboard"),
    //           centerTitle: true,
    //           leading: DrawerWidget(),
    //           actions: [
    //             IconButton(
    //                 onPressed: (() {
    //                   setState(() {
    //                     issearching = !issearching;
    //                   });
    //                 }),
    //                 icon:
    //                     Icon(issearching ? CupertinoIcons.clear : Icons.search))
    //           ],
    //         ),
    //         body: StreamBuilder(
    //             stream: issearching
    //                 ? FirebaseFirestore.instance.collection('users').snapshots()
    //                 : FirebaseFirestore.instance
    //                     .collection('chatrooms')
    //                     .where("participants.${widget.mymodel.id}",
    //                         isEqualTo: true)
    //                     .snapshots(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.active) {
    //                 if (snapshot.hasData) {
    //                   QuerySnapshot datasnapshot =
    //                       snapshot.data as QuerySnapshot;
    //                   if (datasnapshot.docs.length > 0) {
    //                     return ListView.builder(
    //                         padding: EdgeInsets.only(top: 6),
    //                         physics: const BouncingScrollPhysics(),
    //                         itemCount: issearching
    //                             ? searchlist.length
    //                             : datasnapshot.docs.length,
    //                         itemBuilder: (context, index) {
    //                           ChatroomModel chatroom = ChatroomModel.fromJson(
    //                               datasnapshot.docs[index].data()
    //                                   as Map<String, dynamic>);
    //                           Map<String, dynamic>? participants =
    //                               chatroom.participants;
    //                           List<String> participantskeys =
    //                               participants!.keys.toList();
    //                           participantskeys.remove(widget.mymodel.id);

    //                           return FutureBuilder(
    //                             future:
    //                                 utils.getUserModelById(participantskeys[0]),
    //                             builder: (context, tarsnapshot) {
    //                               ChatUser targetuser = tarsnapshot as ChatUser;
    //                               return ChatUserCard(
    //                                 user: issearching
    //                                     ? searchlist[index]
    //                                     : targetuser,
    //                                 me: widget.mymodel,
    //                                 firebaseuser: widget.firebaseuser,
    //                               );
    //                             },
    //                           );
    //                         });
    //                   }
    //                 }
    //                 // Map<String, dynamic> targetuser =
    //                 //     datasnapshot.docs as Map<String, dynamic>;
    //               } else if (snapshot.hasError) {
    //                 return Center(
    //                   child: Text("An error occured"),
    //                 );
    //               } else {
    //                 return Center(
    //                   child: Text("No data found"),
    //                 );
    //               }
    //               return Text("no data");
    //             })),
    //   ),
    // );
  }
}
