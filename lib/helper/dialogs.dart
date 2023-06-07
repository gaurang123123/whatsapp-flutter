import 'package:flutter/material.dart';

class Dialogs {
  static void showSnakbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blueAccent.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressIndicator(BuildContext context) {
    showDialog(
        context: context,
        builder: (((context) =>
            const Center(child: CircularProgressIndicator()))));
  }
}
// navigator.pop(context) to close