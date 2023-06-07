import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hello2/helper/dialogs.dart';

import 'package:hello2/helper/helper.dart';

import 'package:hello2/models/message.dart';
import 'package:hello2/utils/utils.dart';
// import 'package:hello2/model/message.dart';

class Messagecard extends StatefulWidget {
  final Messages message;
  final User? firebaseuser;
  // final ChatroomModel chatroom;

  const Messagecard({
    super.key,
    required this.message,
    required this.firebaseuser,
    // required this.chatroom
  });

  @override
  State<Messagecard> createState() => _MessagecardState();
}

class _MessagecardState extends State<Messagecard> {
  @override
  Widget build(BuildContext context) {
    bool isme = widget.firebaseuser!.uid == widget.message.fromid;
    // return greenmessage();
    return InkWell(
      onLongPress: () {
        showbottomsheet();
        // showModalBottomSheet(context: context, builder: builder)
      },
      child: isme ? greenmessage() : bluemessage(),
    );
  }

  void showbottomsheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                width: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015,
                    horizontal: MediaQuery.of(context).size.width * .04),
                decoration: BoxDecoration(color: Colors.grey),
              ),
              const Text(
                "More options",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              if (widget.message.type == Type.text)
                _optionItems(
                    icon: Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                    ),
                    name: 'Copy Text',
                    ontap: (() async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.message.msg));
                      Navigator.pop(context);
                      Dialogs.showSnakbar(context, 'Text Copied');
                    })),
              if (widget.message.type == Type.image)
                _optionItems(
                    icon: Icon(
                      Icons.download,
                      color: Colors.blue,
                    ),
                    name: 'Image download',
                    ontap: (() async {
                      try {
                        await GallerySaver.saveImage(widget.message.msg,
                                albumName: 'Uchat')
                            .then((success) {
                          Navigator.pop(context);
                          if (success != null && success)
                            Dialogs.showSnakbar(
                                context, 'Image saved successfully.');
                        });
                      } catch (e) {
                        utils().toastMessage(e.toString());
                      }
                    })),
              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.of(context).size.width * .04,
                indent: MediaQuery.of(context).size.height * .04,
              ),
              if (widget.message.fromid == widget.firebaseuser!.uid &&
                  widget.message.type == Type.text)
                _optionItems(
                    icon: Icon(Icons.edit, color: Colors.greenAccent),
                    name: 'Edit Message',
                    ontap: (() {})),
              if (widget.message.fromid == widget.firebaseuser!.uid &&
                  widget.message.type == Type.text)
                _optionItems(
                    icon: Icon(Icons.delete_forever_sharp, color: Colors.red),
                    name: 'Delete Message',
                    ontap: (() async {
                      await helper.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                      });
                    })),
              Divider(
                color: Colors.black54,
                endIndent: MediaQuery.of(context).size.width * .04,
                indent: MediaQuery.of(context).size.height * .04,
              ),
              _optionItems(
                  icon: Icon(Icons.send_sharp, color: Colors.blue),
                  name:
                      'Sent at: ${utils.getLastMessageTime(context: context, time: widget.message.sent)}',
                  ontap: (() {})),
              _optionItems(
                  icon: Icon(Icons.read_more_sharp, color: Colors.blue),
                  name: widget.message.read.isNotEmpty
                      ? 'Read at: ${utils.getLastMessageTime(context: context, time: widget.message.sent)}'
                      : 'Read at: Message not seen yet',
                  ontap: (() {})),
            ],
          );
        });
  }

  Widget bluemessage() {
    if (widget.message.read.isEmpty) {
      helper.updateReadStatus(widget.message);
      log('message read updated');
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(30),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(30)),
            ),
            color: Color.fromARGB(255, 163, 168, 170),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Stack(
              children: [
                Padding(
                  padding: widget.message.type == Type.text
                      ? const EdgeInsets.only(
                          left: 20, right: 60, top: 10, bottom: 30)
                      : const EdgeInsets.only(bottom: 30),
                  child: widget.message.type == Type.text
                      ? Text(
                          widget.message.msg,
                          style: TextStyle(fontSize: 20),
                        )
                      : ClipRRect(
                          // borderRadius: BorderRadius.circular(
                          //     MediaQuery.of(context).size.height * .3),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(utils.getFormatTime(context, widget.message.sent)),
                      // Icon(Icons.done_all),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget greenmessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(10)),
            ),
            color: Color.fromARGB(255, 173, 239, 245),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Stack(
              children: [
                Padding(
                  padding: widget.message.type == Type.text
                      ? const EdgeInsets.only(
                          left: 20, right: 60, top: 10, bottom: 30)
                      : const EdgeInsets.only(bottom: 30),
                  child: widget.message.type == Type.text
                      ? Text(
                          widget.message.msg,
                          style: TextStyle(fontSize: 20),
                        )
                      : ClipRRect(
                          // borderRadius: BorderRadius.circular(
                          //     MediaQuery.of(context).size.height * .3),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  width: 8,
                  // height: 60,
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(utils.getFormatTime(context, widget.message.sent)),
                      SizedBox(
                        width: 5,
                      ),
                      if (widget.message.read.isNotEmpty)
                        const Icon(
                          Icons.done_all,
                          color: Colors.blue,
                        )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class _optionItems extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback ontap;

  const _optionItems(
      {super.key, required this.icon, required this.name, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListTile(
        onTap: ontap,
        title: Text(name),
        leading: icon,
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
