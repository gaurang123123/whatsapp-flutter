// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/authentication/phone.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';
import 'package:pinput/pinput.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId;
  const OtpVerify({super.key, required this.verificationId});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  bool loading = false;
  final otpcontroller = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                "assets/polo.png",
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Verify with Otp",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: otpcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Six Digit Code'),
              ),
              SizedBox(
                height: 40,
              ),
              RoundButton(
                  title: 'Verify phone number',
                  loading: loading,
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpcontroller.text.toString());
                    try {
                      await auth.signInWithCredential(credential);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => PostScreen(),
                      //     ));
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      utils().toastMessage(e.toString());
                    }
                  })),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneLogin(),
                            ));
                      },
                      child: Text(
                        'Edit Phone No ?',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
