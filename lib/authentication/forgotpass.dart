import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/authentication/login1.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  final emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                  padding: EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/pick.png"),
                        fit: BoxFit.fitHeight),
                  )),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email_sharp),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter email";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: RoundButton(
                    title: 'Get Password',
                    loading: loading,
                    onTap: (() {
                      auth
                          .sendPasswordResetEmail(
                              email: emailcontroller.text.toString())
                          .then((value) {
                        utils().toastMessage(
                            'We have send You a email to recover your password');
                        setState(() {
                          loading = true;
                        });
                      }).onError((error, stackTrace) {
                        utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    })),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: Text(
                        "Login To Continue",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ]),
      ),
    );
  }
}
