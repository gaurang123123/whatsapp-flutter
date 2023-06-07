import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/authentication/verify.dart';
import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool loading = false;
  final phonecontroller = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(0, 100, 95, 95),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/polo.png',
                  width: 150,
                  height: 150,
                ),
                Text(
                  'Phone verification',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We need to register your phone before getting started!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                // Row(
                //   children: [
                //     SizedBox(width: 40,)
                //     TextFormField(),
                //     TextFormField(
                //       controller: phonecontroller,
                //       keyboardType: TextInputType.number,
                //       decoration: InputDecoration(hintText: '+91 1123456789'),
                //     ),
                //   ],
                // ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        controller: phonecontroller,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ))
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                RoundButton(
                    title: 'Get OTP',
                    loading: loading,
                    onTap: (() {
                      setState(() {
                        loading = true;
                      });
                      auth.verifyPhoneNumber(
                          phoneNumber:
                              countryController.text + phonecontroller.text,
                          verificationCompleted: ((phoneAuthCredential) {
                            setState(() {
                              loading = false;
                            });
                          }),
                          verificationFailed: ((error) {
                            utils().toastMessage(error.toString());
                            setState(() {
                              loading = false;
                            });
                          }),
                          codeSent: ((String verificationId,
                              int? forceResendingToken) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVerify(
                                    verificationId: verificationId,
                                  ),
                                ));
                            setState(() {
                              loading = false;
                            });
                          }),
                          codeAutoRetrievalTimeout: ((verificationId) {
                            utils().toastMessage(verificationId.toString());
                            setState(() {
                              loading = false;
                            });
                          }));
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
