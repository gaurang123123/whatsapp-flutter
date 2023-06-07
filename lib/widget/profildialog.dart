import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/pages/viewprofile.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height * .35,
        child: Stack(
          children: [
            Text(
              user.name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .25),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.height * .5,
                  // height: MediaQuery.of(context).size.height * .2,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ViewProfile(user: user);
                  },
                ));
              },
              child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.info_outline_rounded)),
            )
          ],
        ),
      ),
    );
  }
}
