import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/authentication/profile.dart';
import 'package:hello2/helper/helper.dart';
import 'package:hello2/models/chatuser.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';
import 'package:pinput/pinput.dart';

import 'login1.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passtoggle = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signup() async {
    UserCredential? credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString());

      User? user = FirebaseAuth.instance.currentUser;
      if (credential != null) {
        log(user!.uid);
        utils().toastMessage(emailController.text);
        log("inside");
        // String uid = _auth.currentUser!.uid;
        // await helper.getUserByEmail(uid, emailController.text.trim());
        // if (credential != null) {
        //   String uid = credential.user!.uid;
        //   log(credential.user!.uid);
        //   DocumentSnapshot userdata = await FirebaseFirestore.instance
        //       .collection('users')
        //       .doc(uid)
        //       .get();
        //   ChatUser mymodel =
        //       ChatUser.fromJson(userdata.data() as Map<String, dynamic>);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePic(
                email: emailController.text,
                firebaseuser: user,
              ),
            ));
        utils().toastMessage("Login to continue...");
        setState(() {
          loading = false;
        });
      }
    } on FirebaseException catch (e) {
      utils().toastMessage(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Signup',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/logintop.png',
              width: 150,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
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
                                  Text(
                                    "Create a account!",
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 200, 18, 18)),
                                  ),
                                  SizedBox(
                                    height: 50,
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
                                            'Enter with numeric character',
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
                        height: 50,
                      ),
                      RoundButton(
                        title: 'Sign up',
                        loading: loading,
                        onTap: () async {
                          if (_formkey.currentState!.validate()) {
                            // print("Login Successful");
                            // emailController.clear();
                            // passwordController.clear();
                            setState(() {
                              loading = true;
                            });
                            signup();
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account?',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ]));
  }
}
