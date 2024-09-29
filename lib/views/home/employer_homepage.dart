import 'package:flutter/material.dart';
import 'package:only_job/views/home/employer_positions.dart';
import 'package:only_job/views/home/employer_profile.dart';

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

          switch (newIndex) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientHomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerPositions()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
          }
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
        fixedColor: Colors.black,
      ),
    );
  }
}
