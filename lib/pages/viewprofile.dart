import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hello2/models/chatuser.dart';
import 'package:hello2/utils/utils.dart';

class ViewProfile extends StatefulWidget {
  final ChatUser user;
  const ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Column(
        children: [
          Row(
            children: [
              Text("Joined On:"),
              SizedBox(
                width: 30,
              ),
              Text(utils.getLastMessageTime(
                  context: context, time: widget.user.createdat))
            ],
          )
        ],
      ),
    );
  }
}
