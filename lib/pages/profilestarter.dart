import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:hello2/helper/api.dart';
import 'package:hello2/helper/dialogs.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/Profilescreen.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileStarter extends StatefulWidget {
  // final usermodel? userModel;
  final User? firebaseuser;
  final ChatUser user;

  const ProfileStarter(
      {super.key, required this.user, required this.firebaseuser});

  @override
  State<ProfileStarter> createState() => _ProfileStarterState();
}

class _ProfileStarterState extends State<ProfileStarter> {
  bool loading = false;
  // String fullname1 = userModel!.fullname.toString();
  File? image;
  // QuerySnapshot snapshot =
  //     FirebaseFirestore.instance.collection("user").doc(userModel.uid).snapshots();
  // usermodel user = snapshot.data() as usermodel;
  // TextEditingController fullnamecontroller =

  // TextEditingController emailcontroller = TextEditingController();
  // TextEditingController fullnamecontroller = TextEditingController();
  // TextEditingController phonecontroller = TextEditingController();

  Future<void> selectimage(ImageSource source) async {
    XFile? pickimage = await ImagePicker().pickImage(source: source);

    if (pickimage != null) {
      File? img = File(pickimage.path);
      cropimage(img);
    }
  }

  Future<File?> cropimage(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedFile != null) {
      setState(() {
        image = File(croppedFile.path);
        log(image!.path);
        // log(image!.path);
        updateProfilePicture(image!);
      });
    }
  }

  Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref =
        FirebaseStorage.instance.ref().child('profile/${widget.user.id}.$ext');
    ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
      ..then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
      });
    widget.user.image = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.user.id)
        .update({'image': widget.user.image});
  }

  void showphotoption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectimage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album_sharp),
                  title: Text("Select from gallery"),
                ),
                ListTile(
                  onTap: (() {
                    Navigator.pop(context);
                    selectimage(ImageSource.camera);
                  }),
                  leading: Icon(Icons.camera_alt_sharp),
                  title: Text("Take a photo"),
                )
              ],
            ),
          );
        });
  }

  // checkvalues() {
  //   if (phonecontroller == null ||
  //       emailcontroller == null ||
  //       fullnamecontroller == null) {
  //     utils().toastMessage("Please Fill the details");
  //     setState(() {
  //       loading = false;
  //     });
  //   } else {
  //     // uploaddata();
  //   }
  // }

  // void uploaddata() async {
  //   if (image != null) {
  //     UploadTask uploadtask = FirebaseStorage.instance
  //         .ref("profilepictures")
  //         .child(widget.userModel!.uid.toString())
  //         .putFile(image!);
  //     TaskSnapshot snapshot = await uploadtask;

  //     String imageurl = await snapshot.ref.getDownloadURL();
  //     widget.userModel!.Profilepic = imageurl;
  //   }
  //   // String fullname = fullnamecontroller.text.trim();
  //   String email = emailcontroller.text.trim();
  //   // String phone = phonecontroller.text.trim();

  //   // widget.userModel!.Profilepic = imageurl;

  //   log(widget.userModel!.email.toString());
  //   FirebaseFirestore.instance
  //       .collection("user")
  //       .doc(widget.userModel!.uid)
  //       .update({
  //     "phonenumber": phonecontroller.text.trim(),
  //     "email": emailcontroller.text.trim(),
  //     "fullname": fullnamecontroller.text.trim(),
  //   }).then((value) {
  //     utils().toastMessage("Uploaded");
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  // uploaddata2() {
  //   log(widget.userModel!.email.toString());
  //   FirebaseFirestore.instance
  //       .collection("user")
  //       .doc(widget.userModel!.uid)
  //       .update({
  //     "phonenumber": fullnamecontroller.text.trim(),
  //     "email": emailcontroller.text.trim(),
  //     "fullname": phonecontroller.text.trim()
  //   }).then((value) {
  //     utils().toastMessage("Uploaded");
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  // void getdata() async {
  //   log(widget.firebaseuser!.uid);
  //   var firestore = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(widget.firebaseuser!.uid)
  //       .get();

  //   setState(() {
  //     String name = firestore.data()!['fullname'];
  //     String email = firestore.data()!['email'];
  //     String phone = firestore.data()!['phonenumber'];
  //     log(name);
  //     log(email);
  //     log(phone);
  //     // var emailcontroller = TextEditingController(text: name);
  //     emailcontroller.text = email;
  //     fullnamecontroller.text = name;
  //     phonecontroller.text = phone;
  //   });
  // }

  // @override
  // void dispose() {
  //   emailcontroller.dispose();
  //   phonecontroller.dispose();
  //   fullnamecontroller.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  // void initState() {
  //   log("first");
  //   getdata();
  //   // TODO: implement initState
  //   super.initState();
  // }

  Future<void> updateuserinfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.firebaseuser!.uid)
        .update({
      'name': widget.user.name,
      'about': widget.user.about,
      'phoneno': widget.user.phoneno,
      'email': widget.user.email,
    });
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Update Profile",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return ProfileScreen(
                  user: widget.user,
                  // firebaseuser: w,
                  // userModel: widget.userModel,
                  firebaseuser: widget.firebaseuser,
                );
              }));
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.black,
          ),
        ),
        body: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Your Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color.fromARGB(255, 58, 9, 9)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .1),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * .2,
                          height: MediaQuery.of(context).size.height * .2,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 1,
                        child: MaterialButton(
                          onPressed: (() {
                            showphotoption();
                          }),
                          elevation: 1,
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ]),
                  ],
                ),
                // CupertinoButton(
                //     child: CircleAvatar(
                //       radius: 60,
                //       backgroundColor: Colors.grey,
                //       backgroundImage: (widget.userModel!.Profilepic != null)
                //           ? NetworkImage(widget.userModel!.Profilepic.toString())
                //           : null,
                //       child: (widget.userModel!.Profilepic == null)
                //           ? const Icon(
                //               Icons.person,
                //               size: 60,
                //             )
                //           : null,
                //     ),
                //     padding: EdgeInsets.all(0),
                //     onPressed: (() {
                //       showphotoption();
                //     })),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  // controller: fullnamecontroller,
                  initialValue: widget.user.name,
                  onSaved: (val) => widget.user.name = val ?? "",
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required Field",

                  // initialValue: widget.userModel!.fullname,
                  decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // controller: emailcontroller,
                  // initialValue: widget.userModel!.email,
                  initialValue: widget.user.email,
                  onSaved: (val) => widget.user.email = val ?? "",
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required Field",
                  decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // controller: phonecontroller,
                  keyboardType: TextInputType.number,
                  initialValue: widget.user.phoneno,
                  onSaved: (val) => widget.user.phoneno = val ?? "",
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required Field",
                  // initialValue: (widget.userModel!.phonenumber != null)
                  //     ? widget.userModel!.phonenumber.toString()
                  // : "Enter phone no",
                  decoration: InputDecoration(
                      labelText: "Phone no",
                      prefixIcon: Icon(Icons.phone_android_sharp),
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: widget.user.about,

                  onSaved: (val) => widget.user.about = val ?? "",
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required Field",
                  // controller: phonecontroller,
                  // keyboardType: TextInputType.number,
                  // initialValue: (widget.userModel!.phonenumber != null)
                  //     ? widget.userModel!.phonenumber.toString()
                  // : "Enter phone no",
                  decoration: InputDecoration(
                      labelText: "About",
                      prefixIcon: Icon(CupertinoIcons.info_circle_fill),
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 50,
                ),
                RoundButton(
                    loading: loading,
                    title: 'Update',
                    onTap: (() async {
                      // checkvalues();
                      if (formkey.currentState!.validate()) {
                        log('inside validator');
                        formkey.currentState!.save();
                        await updateuserinfo().then((value) {
                          Dialogs.showSnakbar(
                              context, "Profile Updated Succesfully.");
                        });
                      }
                      // setState(() {
                      //   loading = true;
                      //   checkvalues();
                      // });

                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return ProfileStarter(
                      //     userModel: widget.userModel,
                      //     firebaseuser: widget.firebaseuser,
                      //   );
                      // }));
                    })),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
