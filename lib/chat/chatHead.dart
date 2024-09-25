import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatHead extends StatefulWidget {
  const chatHead({super.key});

  @override
  State<chatHead> createState() => _chatHeadState();
}

class _chatHeadState extends State<chatHead> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("user"),
      ),
    );
  }
}