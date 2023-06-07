// import 'dart:developer';
// import 'dart:ffi';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:uuid/uuid.dart';

// var uuid = Uuid();
// // late Size mq;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
//       .then((value) async {
//     await Firebase.initializeApp();
//     User? currentuser = FirebaseAuth.instance.currentUser;

//     // User? currentuser = FirebaseAuth.instance.currentUser;
//     if (currentuser != null) {
//       // usermodel? thisusermodel =
//       //     await FirebaseHelper.getUserModelById(currentuser.uid);
//       // if (thisusermodel != null) {
//       log("hello");
//       runApp(MyApploggedin());
//       // }
//     } else {
//       runApp(MyApp());
//     }
//   });
// }
// // void main() {
// //   runApp(MyApp());
// // }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // ignore: prefer_const_constructors
//       // home: HomePage(),
//       home: HomePage(),
//       debugShowCheckedModeBanner: false,
//       // color: Colors.indigo[900]
//     );
//   }
// }

// class MyApploggedin extends StatelessWidget {
//   // final usermodel userModel;
//   // final User firebaseuser;

//   const MyApploggedin({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // ignore: prefer_const_constructors
//       // home: HomeWindow(userModel: userModel, firebaseuser: firebaseuser),
//       // home: Home(userModel: userModel, firebaseuser: firebaseuser),
//       // home: SplashScreen(

//       ),
//       debugShowCheckedModeBanner: false,
//       // color: Colors.indigo[900]
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hello2/authentication/login1.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/zoomprofile.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  User? currentuser = FirebaseAuth.instance.currentUser;

  if (currentuser != null) {
    ChatUser? mymodel = await helper.getChatUserById(currentuser.uid);
    if (mymodel != null) {
      runApp(MyAppLogedIn(
        mymodel: mymodel,
        firebaseuser: currentuser,
      ));
    }
  } else {
    runApp(MyApp());
  }
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: prefer_const_constructors
      // home: HomePage(),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      // color: Colors.indigo[900]
    );
  }
}

class MyAppLogedIn extends StatelessWidget {
  final ChatUser mymodel;
  final User firebaseuser;

  const MyAppLogedIn(
      {super.key, required this.mymodel, required this.firebaseuser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: prefer_const_constructors
      // home: HomePage(),
      home: Home(
        mymodel: mymodel,
        firebaseuser: firebaseuser,
      ),
      debugShowCheckedModeBanner: false,
      // color: Colors.indigo[900]
    );
  }
}
