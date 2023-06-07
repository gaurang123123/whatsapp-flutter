import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:hello2/helper/api.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/main.dart';
import 'package:hello2/models/chatroommodel.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/models/message.dart';
import 'package:hello2/pages/chatscreen.dart';
import 'package:hello2/pages/viewprofile.dart';
import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/profildialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final ChatUser? me;
  final User? firebaseuser;
  const ChatUserCard(
      {super.key,
      required this.user,
      required this.me,
      required this.firebaseuser});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // ChatUser? firebaseuser;

  // late ChatroomModel chatroommodel;
  Messages? message;
  var messagelen;

  // Future<ChatroomModel?> getChatRoomModel(ChatUser user) async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('chatrooms')
  //       .where("participants.${widget.me!.id}", isEqualTo: true)
  //       .where("participants.${widget.user.id}", isEqualTo: true)
  //       .get();

  //   if (snapshot.docs.length > 0) {
  //     //fetch existing

  //     var docdata = snapshot.docs[0].data();
  //     ChatroomModel existingChatroom =
  //         ChatroomModel.fromJson(docdata as Map<String, dynamic>);
  //     chatroommodel = existingChatroom;
  //     log("existing user");
  //   } else {
  //     ChatroomModel newchatroom =
  //         ChatroomModel(chatroomid: uuid.v1(), lastmessage: "", participants: {
  //       widget.user.id.toString(): true,
  //       widget.me!.id.toString(): true,
  //     });
  //     await FirebaseFirestore.instance
  //         .collection('chatrooms')
  //         .doc(newchatroom.chatroomid)
  //         .set(newchatroom.toJson());
  //     chatroommodel = newchatroom;
  //     log("new user created");
  //   }
  //   return chatroommodel;
  // }

  @override
  void initState() {
    // TODO: implement initState
    log(widget.user.image);
    // firebaseuser = api.me;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ChatroomModel? chatroommodel;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(5),
      child: InkWell(
          onTap: () {
            // chatroommodel = await getChatRoomModel(widget.user);
            // if (chatroommodel != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          // chatroom: chatroommodel!,
                          user: widget.user,
                          mymodel: widget.me,
                          firebaseuser: widget.firebaseuser,
                        )));
            // }
            //  Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => ChatScreen(
            //                 // chatroom: chatroommodel,
            //                 user: widget.user,
            //               )));
          },
          child: StreamBuilder(
            stream: helper.getLastMessage(widget.user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  final list =
                      data.map((e) => Messages.fromJson(e.data())).toList();
                  if (list.isNotEmpty) {
                    message = list[0];
                    messagelen = list.length;
                  }
                }
              }

              return ListTile(
                  title: Text(
                    widget.user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Row(
                    children: [
                      if (message != null &&
                          message!.fromid != widget.firebaseuser!.uid)
                        Icon(Icons.keyboard_double_arrow_down_outlined),
                      Text(
                          message != null
                              ? message!.type == Type.image
                                  ? 'image'
                                  : message!.msg
                              : widget.user.about,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: message != null &&
                                      message!.fromid !=
                                          widget.firebaseuser!.uid
                                  ? Color.fromARGB(255, 85, 238, 58)
                                  : Colors.grey)),
                    ],
                  ),
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(widget.user.image),
                  // ),
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ProfileDialog(
                              user: widget.user,
                            );
                          }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * .3),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .055,
                        height: MediaQuery.of(context).size.height * .055,

                        imageUrl: widget.user.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                  trailing: message == null
                      ? null
                      : message!.read.isEmpty &&
                              message!.fromid != widget.firebaseuser!.uid
                          ? Column(
                              children: [
                                Text(utils.getLastMessageTime(
                                    context: context, time: message!.sent)),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    messagelen.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ],
                            )
                          : Text(utils.getLastMessageTime(
                              context: context, time: message!.sent)));
            },
          )),
    );
  }
}
