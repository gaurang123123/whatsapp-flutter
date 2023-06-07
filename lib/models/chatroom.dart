// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:hello2/main.dart';

// import 'package:hello2/utils/chatroommodel.dart';
// import 'package:hello2/utils/messagemodel.dart';

// class ChatRoom extends StatefulWidget {
//   final usermodel targetuser;
//   final chatroommodel chatroom;
//   final usermodel? userModel;
//   final User? firebaseuser;

//   const ChatRoom(
//       {super.key,
//       required this.targetuser,
//       required this.chatroom,
//       required this.userModel,
//       required this.firebaseuser});

//   @override
//   State<ChatRoom> createState() => _ChatRoomState();
// }

// class _ChatRoomState extends State<ChatRoom> {
//   TextEditingController messagecontroller = TextEditingController();

//   void sendmessage() async {
//     log("send message");
//     String msg = messagecontroller.text.trim();
//     // messagecontroller.clear();
//     if (msg != "") {
//       MessageModel newmessage = MessageModel(
//         messageid: uuid.v1(),
//         sender: widget.userModel!.uid,
//         createdon: DateTime.now(),
//         text: msg,
//         seen: false,
//       );
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatroom.chatroomid)
//           .collection("messages")
//           .doc(newmessage.messageid)
//           .set(newmessage.toMap());
//       widget.chatroom.lastMessage = msg;
//       // widget.chatroom.createdon = DateTime.now();
//       log(DateTime.now().toString());
//       FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(widget.chatroom.chatroomid)
//           .set(widget.chatroom.toMap());
//       log("message send");
//       // messagecontroller.clear();
//     } else {}
//     messagecontroller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey,
//               backgroundImage:
//                   NetworkImage(widget.targetuser.Profilepic.toString()),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Text(widget.targetuser.fullname.toString()),
//           ],
//         ),
//       ),
//       body: SafeArea(
//           child: Container(
//         child: Column(
//           children: [
//             Expanded(
//                 child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection("chatrooms")
//                       .doc(widget.chatroom.chatroomid)
//                       .collection("messages")
//                       .orderBy("createdon", descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.active) {
//                       if (snapshot.hasData) {
//                         QuerySnapshot datasnapshot =
//                             snapshot.data as QuerySnapshot;
//                         return ListView.builder(
//                           reverse: true,
//                           itemCount: datasnapshot.docs.length,
//                           itemBuilder: (context, index) {
//                             MessageModel currentmessage = MessageModel.fromMap(
//                                 datasnapshot.docs[index].data()
//                                     as Map<String, dynamic>);
//                             return Row(
//                               mainAxisAlignment: (currentmessage.sender ==
//                                       widget.userModel!.uid)
//                                   ? MainAxisAlignment.end
//                                   : MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                     margin: EdgeInsets.symmetric(vertical: 4),
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 10),
//                                     decoration: BoxDecoration(
//                                         color: (currentmessage.sender ==
//                                                 widget.userModel!.uid)
//                                             ? Colors.grey
//                                             : Theme.of(context)
//                                                 .colorScheme
//                                                 .secondary,
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     child: Text(
//                                       currentmessage.text.toString(),
//                                       style: TextStyle(
//                                           color:
//                                               Color.fromARGB(255, 213, 62, 20)),
//                                     )),
//                               ],
//                             );
//                           },
//                         );
//                       } else if (snapshot.hasError) {
//                         return Center(
//                           child: Text("An error occured"),
//                         );
//                       } else {
//                         return Center(
//                           child: Text("Say hello"),
//                         );
//                       }
//                     }
//                     return Text("h");
//                   }),
//             )),
//             Container(
//               margin: EdgeInsets.all(4),
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               color: Colors.grey,
//               child: Row(
//                 children: [
//                   Flexible(
//                       child: TextField(
//                     controller: messagecontroller,
//                     maxLines: null,
//                     decoration: InputDecoration(hintText: "Enter message"),
//                   )),
//                   IconButton(
//                       onPressed: () {
//                         sendmessage();
//                       },
//                       icon: Icon(
//                         Icons.send,
//                         color: Colors.deepOrangeAccent,
//                       ))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
