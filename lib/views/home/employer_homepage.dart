import 'package:flutter/material.dart';
import 'package:only_job/views/home/employer_positions.dart';
import 'package:only_job/views/home/employer_profile.dart';
import 'package:only_job/services/skills_uploader.dart';

import '../../chatFeature/mainChatPage.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _currentIndex = 0;

  // pages to toggle when the BottomNavigationBarItem is clicked
  final List<Widget> _pages = [
    Icon(Icons.home),
    EmployerPositions(),
    SkillsUploader(),
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
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Positions',
            icon: Icon(Icons.business_outlined),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Applicants',
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Menu',
            icon: Icon(Icons.messenger_outline_rounded),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        fixedColor: Colors.black,
      ),
    );
  }
}
