import 'dart:developer';
import 'dart:ffi';
// import 'dart:js';
// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hello2/authentication/forgotpass.dart';
import 'package:hello2/authentication/phone.dart';
import 'package:hello2/authentication/profile.dart';
import 'package:hello2/authentication/signup.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/zoomprofile.dart';
import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';

import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserCredential? credential;
  late ChatUser mymodel;
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passtoggle = true;

  final _auth = FirebaseAuth.instance;

  // final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> login() async {
    setState(() {
      loading = true;
    });
    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (credential != null) {
        String uid = credential!.user!.uid;
        log(credential!.user!.uid);
        DocumentSnapshot userdata =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        ChatUser mymodel =
            ChatUser.fromJson(userdata.data() as Map<String, dynamic>);

        // log(mymodel.toString());
        User? currentuser = await FirebaseAuth.instance.currentUser;
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                mymodel: mymodel,
                firebaseuser: currentuser,
              ),
            ));
      }
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      utils().toastMessage(e.toString());
    }
    // if (Credential != null) {
    //   String uid = user!.uid;
    //   usermodel newuser = usermodel(
    //       uid: uid,
    //       email: emailController.text.toString(),
    //       phonenumber: "Phone no");
    //   await FirebaseFirestore.instance
    //       .collection("user")
    //       .doc(uid)
    //       .set(newuser.toMap())
    //       .then((value) {
    //     print("new user stored");
    //   });
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) =>
    //             ProfilePic(userModel: newuser, firebaseuser: user),
    //       ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     'Login',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   backgroundColor: Colors.transparent,
        // ),
        body: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 0,
            // left: 0,
            child: Image.asset(
              'assets/best.png',
              // width: 300,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/login_bottom.png',
              width: 200,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ));
                                      },
                                      child: Text(
                                        "Welcome Back!",
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 231, 217, 217)),
                                      )),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      helperText:
                                          'Enter email eg abc@gmail.com',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      prefixIcon: Icon(Icons.email)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: passtoggle,
                                  decoration: InputDecoration(
                                      hintText: 'Password',
                                      helperText:
                                          'Enter with special character',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      prefixIcon: Icon(Icons.lock),
                                      suffix: InkWell(
                                        onTap: () {
                                          setState(() {
                                            passtoggle = !passtoggle;
                                          });
                                        },
                                        child: Icon(passtoggle
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      )),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Password";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                      title: 'Login',
                      loading: loading,
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          login();
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don`t have account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupPage(),
                                  ));
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 300),
                      child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneLogin(),
                              ));
                        },
                        icon: Icon(Icons.phone_android_outlined),
                        label: Text("Login with Phoneno",
                            style: TextStyle(fontSize: 20)),
                        backgroundColor: Color.fromARGB(255, 25, 192, 204),
                        foregroundColor: Color.fromARGB(95, 11, 11, 11),
                        elevation: 30,
                        tooltip: "OTP Verification",
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 300),
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          // await FirebaseServices().signinwithgoogle();
                          // // ignore: use_build_context_synchronously
                          // Dialogs.showSnakbar(
                          //     context, "Login to Google Succesful");
                          // Dialogs.showProgressIndicator(context);
                          // Navigator.pop(context);
                          // if (await api.userExist()) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (_) => Dashboard(
                          //           me: api.me,
                          //         ),
                          //       ));
                          // } else {
                          //   await api.createUser().then((value) {
                          //     Navigator.pushReplacement(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (_) => Dashboard(
                          //             me: api.me,
                          //           ),
                          //         ));
                          //   });
                          // }
                        },
                        icon: Image.asset(
                          "assets/google.jpg",
                          width: 40,
                          height: 40,
                        ),
                        label: Text(
                          "Login with Google",
                          style: TextStyle(fontSize: 20),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black38,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 100),
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/background.png"),
                              fit: BoxFit.fitHeight),
                        )),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
