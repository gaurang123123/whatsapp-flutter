import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello2/models/chatuser.dart';

class utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String getFormatTime(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    if (now.year != sent.year) {
      return '${sent.year}';
    } else {
      return '${sent.day}/${sent.month}';
    }
  }

  static String getLastActiveTime(
      {required BuildContext context, required String time}) {
    final int i = int.tryParse(time) ?? -1;
    if (i == -1) {
      return 'Last seen not available';
    }
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return 'Last seen today at ${TimeOfDay.fromDateTime(sent).format(context)}';
    }
    if (now.year != sent.year) {
      return 'Last seen on ${sent.year}';
    } else {
      return 'Last seen on ${sent.day} ${sent.month} on ${sent.hour}:${sent.minute} ${sent.isUtc}';
    }
  }

  static Future<ChatUser?> getUserModelById(String uid) async {
    ChatUser? chatuser;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docsnap != null) {
      chatuser = ChatUser.fromJson(docsnap.data() as Map<String, dynamic>);
    }
    return chatuser;
  }
}
