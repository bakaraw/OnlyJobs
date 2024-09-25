import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatHome extends StatefulWidget {
  const chatHome({super.key});

  @override
  State<chatHome> createState() => _chatHomeState();
}

class _chatHomeState extends State<chatHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home page"),
      ),
    );
  }
}