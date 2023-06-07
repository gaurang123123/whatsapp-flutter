// import 'dart:developer';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:hello2/model/chatuser.dart';
// import 'package:hello2/model/message.dart';

// class api {
//   static FirebaseAuth auth = FirebaseAuth.instance;
//   static late ChatUser me;
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   static User get user => auth.currentUser!;
//   static var firebase;
//   static FirebaseStorage firestorage = FirebaseStorage.instance;

//   static Future<bool> userExist() async {
//     return (await firestore.collection('user').doc(auth.currentUser!.uid).get())
//         .exists;
//   }

//   static Future<void> updateuserinfo() async {
//     firestore.collection('user').doc(auth.currentUser!.uid).update({
//       'name': me.name,
//       'about': me.about,
//       'phoneno': me.phoneno,
//       'email': me.email,
//     });
//   }

//   static Future<void> getselfinfo() async {
//     await firestore
//         .collection('user')
//         .doc(user.uid)
//         .get()
//         .then((user) async => {
//               if (user.exists)
//                 {me = ChatUser.fromJson(user.data()!)}
//               else
//                 {await createUser().then((value) => getselfinfo())}
//             });
//   }

//   static Future<void> createUser() async {
//     final time = DateTime.now().microsecondsSinceEpoch.toString();

//     final chatuser = ChatUser(
//         image: user.photoURL.toString(),
//         createdat: time,
//         name: user.displayName.toString(),
//         about: "Hey! I am using Uchat",
//         pushtoken: "",
//         idonline: false,
//         id: user.uid,
//         email: user.email.toString(),
//         phoneno: "",
//         lastactive: time);

//     return await firestore
//         .collection('user')
//         .doc(user.uid)
//         .set(chatuser.toJson());
//   }

//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
//     return firestore
//         .collection('user')
//         .where('id', isNotEqualTo: user.uid)
//         .snapshots();
//   }

//   static Future<void> updateProfilePicture(File file) async {
//     final ext = file.path.split('.').last;
//     final ref = firestorage.ref().child('profile/${user.uid}.$ext');
//     ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
//       ..then((p0) {
//         log('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
//       });
//     me.image = await ref.getDownloadURL();
//     await firestore
//         .collection('user')
//         .doc(user.uid)
//         .update({'image': me.image});
//   }

//   // static getConversationID(String id) => user.uid.hashCode <= id.hashCode
//   //     ? '${user.uid}_$id'
//   //     : '${id}_${user.uid}';
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
//       String chatroomid, ChatUser user) {
//     return firestore
//         .collection('chatrooms')
//         .doc(chatroomid)
//         .collection('messages')
//         .snapshots();
//   }

//   // static Future<void> sendMessage(ChatUser targetuser, String msg) async {
//   //   final time = DateTime.now().millisecondsSinceEpoch.toString();
//   //   final Messages message = Messages(
//   //       toid: targetuser.id,
//   //       msg: msg,
//   //       read: '',
//   //       type: Type.text,
//   //       fromid: user.uid,
//   //       sent: time);
//   //   final ref = firestore
//   //       .collection('chats/${getConversationID(targetuser.id)}/messages/');

//   //   await ref.doc(time).set(message.toJson());
//   // }
//   static Future<void> sendMessage(
//       ChatUser targetuser, String msg, String chatroomid) async {
//     log(chatroomid);
//     log(msg);
//     log(targetuser.about);
//     final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final Messages message = Messages(
//         toid: targetuser.id,
//         msg: msg,
//         read: '',
//         // type: Type.text,
//         fromid: user.uid,
//         sent: time);
//     firestore
//         .collection("chatrooms")
//         .doc(chatroomid)
//         .collection("messages")
//         .doc(time)
//         .set(message.toJson());
//   }
// }
