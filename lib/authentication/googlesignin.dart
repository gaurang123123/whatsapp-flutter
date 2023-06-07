import 'dart:developer';
import 'dart:io';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:hello2/utils/utils.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googlesignin = GoogleSignIn();

  signinwithgoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleSignInAccount =
          await googlesignin.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await auth.signInWithCredential(authCredential);
        print("Result $googleSignInAccount");
        print(googleSignInAccount.displayName);
        print(googleSignInAccount.email);
        print(googleSignInAccount.photoUrl);
        log('user: ${FirebaseAuth.instance.currentUser}');
      }
    } on FirebaseException catch (e) {
      // Dialogs.showSnakbar(context , e);
      utils().toastMessage(e.toString());
      throw e;
    }
  }

  signout() async {
    await auth.signOut().then((value) async {
      CircularProgressIndicator();
      await googlesignin.signOut();
    });
  }
}
