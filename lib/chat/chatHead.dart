import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chat/chatRoom.dart';

class chatHead extends StatefulWidget {
  const chatHead({

    super.key,
    required this.chatRoom,
  });

  final ChatRoom chatRoom;

  @override
  State<chatHead> createState() => _chatHeadState();
}

final TextEditingController message = TextEditingController();

class _chatHeadState extends State<chatHead> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Name"),
      ),
      body: Container(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 60,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: "Type message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  ),

                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
              onPressed: () {}
                  ),
            ],
          ),
        ),

      );

  }
}