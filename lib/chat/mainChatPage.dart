import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chat/chatHome.dart';
import 'package:only_job/chat/chatHead.dart';

class mainChatPage extends StatefulWidget {
  const mainChatPage({super.key});

  @override
  State<mainChatPage> createState() => _mainChatPageState();
}

class _mainChatPageState extends State<mainChatPage> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    chatHome(),
   chatHead(),
  ];

  void tapped(int index) {
    setState(() {
      selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat messager"),
        actions: [
          Padding(
           padding: EdgeInsets.all(8.8),
          child: CircleAvatar(
            radius: 10,
          ),
          )
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Chat List',
        ),
          BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chat',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: tapped,

      ),
    );
  }
}
