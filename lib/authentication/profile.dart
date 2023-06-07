// import 'dart:developer';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/zoomprofile.dart';

import 'package:hello2/utils/utils.dart';
import 'package:hello2/widget/roundbutton.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  // final ChatUser myModel;
  final User? firebaseuser;
  final String email;
  const ProfilePic(
      {Key? key,
      // required this.myModel,
      required this.firebaseuser,
      required this.email});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    // log(widget.myModel.email);
    super.initState();
  }

  File? image;
  TextEditingController fullnamecontroller = TextEditingController();
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
        print(image!.path);
        // log(image!.path);
      });
    }
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

  void checkvalues() {
    String fullname = fullnamecontroller.text.trim();

    if (fullname == "" || image == null) {
      utils().toastMessage("Please Fill the details");
      setState(() {
        loading = false;
      });
    } else {
      uploaddata();
    }
  }

  void uploaddata() async {
    final ext = image!.path.split('.').last;

    UploadTask uploadtask = FirebaseStorage.instance
        .ref()
        .child('profile/${widget.firebaseuser!.uid}.$ext')
        .putFile(image!);
    TaskSnapshot snapshot = await uploadtask;

    String imageurl = await snapshot.ref.getDownloadURL();
    String fullname = fullnamecontroller.text.trim();
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(
        image: imageurl,
        createdat: time,
        name: fullname,
        about: "Hey! I am using Uchat",
        pushtoken: "",
        idonline: false,
        id: widget.firebaseuser!.uid,
        email: widget.email,
        phoneno: "",
        lastactive: time);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.firebaseuser!.uid)
        .set(chatuser.toJson());

    DocumentSnapshot userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.firebaseuser!.uid)
        .get();
    ChatUser mymodel =
        ChatUser.fromJson(userdata.data() as Map<String, dynamic>);

    // widget.myModel.name = fullname;
    // widget.myModel.image = imageurl;

    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(widget.myModel.id)
    //     .set(widget.myModel.toJson())
    //     .then((value) => utils().toastMessage("Picture Uploaded"));
    // setState(() {
    //   loading = false;
    // });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            mymodel: mymodel,
            firebaseuser: widget.firebaseuser,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Complete Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.redAccent),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            CupertinoButton(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  backgroundImage: (image != null) ? FileImage(image!) : null,
                  child: (image == null)
                      ? const Icon(
                          Icons.person,
                          size: 60,
                        )
                      : null,
                ),
                padding: EdgeInsets.all(0),
                onPressed: (() {
                  showphotoption();
                })),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: fullnamecontroller,
              decoration: InputDecoration(
                hintText: 'Full Name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
                title: 'Submit',
                loading: loading,
                onTap: (() {
                  setState(() {
                    loading = true;
                  });
                  checkvalues();
                }))
          ],
        ),
      )),
    );
  }
}
