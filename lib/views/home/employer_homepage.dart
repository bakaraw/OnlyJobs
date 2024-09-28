import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _currentIndex = 0;

  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.people),
    Icon(Icons.menu),
    Icon(Icons.person),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
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
              icon: Icon(Icons.menu),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              label: 'Profile',
              icon: Icon(Icons.person),
            ),
          ],
          fixedColor: Colors.black),
    );
  }
}
