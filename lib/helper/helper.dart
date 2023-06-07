import 'dart:developer';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:hello2/models/chatuser.dart';
import 'package:hello2/models/message.dart';
import 'package:hello2/utils/utils.dart';

class helper {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseStorage firestorage = FirebaseStorage.instance;
  static User? user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static late ChatUser me;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.getToken().then((value) => {
          if (value != null) {me.pushtoken = value, log(value)}
        });
  }

  static Future<void> getUserByEmail(String uid, email) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final mymodel = ChatUser(
        image: "",
        createdat: time,
        name: "",
        about: "Hey I am Using UChat",
        pushtoken: "",
        idonline: true,
        id: uid,
        email: email,
        lastactive: time,
        phoneno: "");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(mymodel.toJson());
  }

  static Future<ChatUser?> getChatUserById(String uid) async {
    ChatUser? mymodel;

    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docsnap.data() != null) {
      mymodel = ChatUser.fromJson(docsnap.data() as Map<String, dynamic>);
    }
    return mymodel;
  }

  static Future<void> sendMessage(
      ChatUser? mymodel, ChatUser targetuser, String msg, Type type) async {
    // log(chatroom.chatroomid.toString());
    log(msg);
    log(targetuser.about);
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages message = Messages(
        toid: targetuser.id,
        msg: msg,
        read: '',
        type: type,
        fromid: mymodel!.id,
        sent: time);
    firestore
        .collection('chats/${getConversationID(targetuser.id)}/messages/')
        .doc(time)
        .set(message.toJson());

    // chatroom.lastmessage = msg;
    // firestore
    //     .collection("chatrooms")
    //     .doc(chatroom.chatroomid)
    //     .set(chatroom.toJson());
  }

  static Future<void> updateReadStatus(Messages message) async {
    await FirebaseFirestore.instance
        .collection('chats/${getConversationID(message.fromid)}/messages/')
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // static Future<void> updatePicture(File file, ChatroomModel chatroomModel,
  //     ChatUser? mymodel, ChatUser targetuser) async {
  //   final ext = file.path.split('.').last;
  //   final ref = firestorage.ref().child(
  //       'images/${chatroomModel.chatroomid}/${DateTime.now().millisecondsSinceEpoch}.$ext');
  //   ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //     ..then((p0) async {
  //       log('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
  //       utils()
  //           .toastMessage('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
  //       final imageurl = await ref.getDownloadURL();
  //       log(imageurl);
  //       await sendMessage(
  //           mymodel, targetuser, imageurl, chatroomModel, Type.image);
  //     });
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // static String getChatRoomId(String targetid) {
  //   if (user!.uid[0].toLowerCase().codeUnits[0] >
  //       targetid.toLowerCase().codeUnits[0]) {
  //     return '${user!.uid}_${targetid}';
  //   } else {
  //     return '${targetid}_${user!.uid}';
  //   }
  // }

  static String getConversationID(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user!.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      ChatUser? chatuser) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(chatuser!.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendChatImage(
      ChatUser user, File file, ChatUser? mymodel) async {
    // return FirebaseFirestore.instance.collection('')
    final ext = file.path.split('.').last;
    final ref = firestorage.ref().child(
        'images/${getConversationID(user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
      utils()
          .toastMessage('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
    });
    final imageurl = await ref.getDownloadURL();
    log(imageurl);
    await sendMessage(mymodel, user, imageurl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser user, ChatUser? mymodel) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(
      bool isonline, ChatUser? mymodel) async {
    FirebaseFirestore.instance.collection('users').doc(mymodel!.id).update({
      'idonline': isonline,
      'lastactive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushtoken': me.pushtoken
    });
  }

  static Future<void> getselfinfo() async {
    log("inside self info");
    await firestore.collection('users').doc(user!.uid).get().then((user) => {
          if (user.exists)
            {
              me = ChatUser.fromJson(user.data()!),
              log(me.name),
              getFirebaseMessagingToken(),
              helper.updateActiveStatus(true, me),
            }
          // else
          //   {await createUser().then((value) => getselfinfo())}
        });
  }

  static Future<void> deleteMessage(Messages message) async {
    log("inside delete");
    await firestore
        .collection('chats/${getConversationID(message.toid)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image)
      await firestorage.refFromURL(message.msg).delete();
  }
}
