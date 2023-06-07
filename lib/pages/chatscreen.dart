import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/helper/api.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/models/chatroommodel.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/models/message.dart';
import 'package:hello2/pages/viewprofile.dart';
import 'package:hello2/utils/utils.dart';

import 'package:hello2/widget/messagecard.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  // final ChatroomModel chatroom;
  final ChatUser? mymodel;
  final User? firebaseuser;
  const ChatScreen(
      {super.key,
      required this.user,
      // required this.chatroom,
      required this.mymodel,
      required this.firebaseuser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final ChatUser firebaseuser = api.me;

  List<Messages> list = [];
  final Textcontroller = TextEditingController();
  bool showemoji = false;
  bool isuploading = false;
  @override
  @override
  build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Image.asset(
            "assets/whatsapp.jpg",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          WillPopScope(
            onWillPop: () {
              if (showemoji) {
                setState(() {
                  showemoji = !showemoji;
                });

                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: _appBar(),
                ),
                body: Column(
                  children: [
                    Expanded(
                        child: StreamBuilder(
                            stream: helper.getAllMessage(widget.user),

                            //  helper.getAllMessage(widget.user),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.hasData) {
                                  QuerySnapshot datasnapshot =
                                      snapshot.data as QuerySnapshot;
                                  if (datasnapshot.docs.length > 0) {
                                    final data = snapshot.data?.docs;
                                    log('data ${jsonEncode(data![0].data())}');
                                    list = data
                                            .map((e) =>
                                                Messages.fromJson(e.data()))
                                            .toList() ??
                                        [];
                                    log(list.toString());

                                    if (list.isNotEmpty) {
                                      return ListView.builder(
                                        reverse: true,
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.only(top: 5),
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Messagecard(
                                            message: list[index],
                                            firebaseuser: widget.firebaseuser,
                                            // chatroom: widget.chatroom,
                                          );
                                        },
                                      );
                                    }
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                return Center(
                                    child: Text(
                                  "Say Hii! 🤚",
                                  style: TextStyle(fontSize: 25),
                                ));
                              } else if (!snapshot.hasData)
                                return Center(
                                    child: Text(
                                  "Say Hii! 🤚",
                                  style: TextStyle(fontSize: 25),
                                ));
                              return Center(child: CircularProgressIndicator());
                            })),
                    if (isuploading)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    chatinput(),
                    if (showemoji)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: EmojiPicker(
                          textEditingController:
                              Textcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                          config: Config(
                            columns: 8,
                            emojiSizeMax: 32 *
                                (Platform.isIOS
                                    ? 1.30
                                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894

                            bgColor: Color(0xFFF2F2F2),
                            initCategory: Category.RECENT,

                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ), // Needs to be const Widget
                            loadingIndicator: const SizedBox
                                .shrink(), // Needs to be const Widget
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewProfile(
                user: widget.user,
              ),
            ));
      }),
      child: StreamBuilder(
        stream: helper.getUserInfo(widget.user, widget.mymodel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .03),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .055,
                      height: MediaQuery.of(context).size.height * .055,
                      fit: BoxFit.fill,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].idonline
                                ? 'Online'
                                : utils.getLastActiveTime(
                                    context: context, time: list[0].lastactive)
                            : utils.getLastActiveTime(
                                context: context, time: widget.user.lastactive),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      )
                    ],
                  )
                ],
              );
              // if(list.isNotEmpty)
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget chatinput() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(children: [
        Expanded(
          child: Card(
            shadowColor: Colors.amberAccent,
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showemoji = !showemoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.red,
                    )),
                Expanded(
                    child: TextField(
                  controller: Textcontroller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () {
                    if (showemoji)
                      setState(() {
                        showemoji = !showemoji;
                      });
                  },
                  decoration: InputDecoration(
                      hintText: "Type something..", border: InputBorder.none),
                )),
                IconButton(
                    onPressed: () async {
                      File img;

                      final List<XFile> pickimages =
                          await ImagePicker().pickMultiImage(imageQuality: 80);

                      for (var element in pickimages) {
                        log(element.path);
                        setState(() {
                          isuploading = true;
                        });
                        await helper.sendChatImage(
                            widget.user, File(element.path), widget.mymodel);
                        setState(() {
                          isuploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: () async {
                      final XFile? pickimage = await ImagePicker().pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (pickimage != null) {
                        log(pickimage.path);
                        setState(() {
                          isuploading = true;
                        });
                        await helper.sendChatImage(
                            widget.user, File(pickimage.path), widget.mymodel);
                        // await helper.updatePicture(File(pickimage.path),
                        //     widget.chatroom, widget.mymodel, widget.user);
                        setState(() {
                          isuploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ),
        MaterialButton(
          minWidth: 0,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          onPressed: (() async {
            if (Textcontroller.text.isNotEmpty) {
              // log(widget.chatroom.chatroomid.toString());
              await helper.sendMessage(widget.mymodel, widget.user,
                  Textcontroller.text.trim(), Type.text);
              Textcontroller.clear();
            }
          }),
          shape: CircleBorder(),
          color: Colors.red,
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 26,
          ),
        )
      ]),
    );
  }
}
