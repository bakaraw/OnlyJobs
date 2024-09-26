import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatList extends StatefulWidget {
  const chatList({super.key});

  @override
  State<chatList> createState() => _chatListState();
}

class _chatListState extends State<chatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Chat"),
      ),
    );
  }
}
