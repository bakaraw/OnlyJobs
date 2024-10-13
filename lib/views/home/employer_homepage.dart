import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/home/employer_positions.dart';
import 'package:only_job/views/home/employer_profile.dart';
import 'package:only_job/services/skills_uploader.dart';
import '../../chatFeature/main_chat_page.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EmployerPositions(),
    MainChatPage(),
    EmployerProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primarycolor,
        selectedLabelStyle: bodyStyle,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: primarycolor,
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: primarycolor,
            label: 'Chat',
            icon: Icon(Icons.messenger_outline_rounded),
          ),
          BottomNavigationBarItem(
            backgroundColor: primarycolor,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        fixedColor: secondarycolor,
      ),
    );
  }
}
