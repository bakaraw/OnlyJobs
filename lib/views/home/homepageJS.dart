import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/home/profileJS.dart';

class HomePageJS extends StatefulWidget {
  @override
  _HomePageJSState createState() => _HomePageJSState();
}

class _HomePageJSState extends State<HomePageJS> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProfileScreen(),
    ChatPage(),
    AddPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: accent1,
        items: <Widget>[
          Icon(Icons.person, size: 30, color: backgroundwhite),
          Icon(Icons.chat, size: 30, color: backgroundwhite),
          Icon(Icons.add, size: 30, color: backgroundwhite),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

//checking the navigation
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chat Page'),
    );
  }
}

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Add Page'),
    );
  }
}
