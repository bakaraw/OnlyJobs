import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:only_job/views/JS_view/job_seeker_home.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/JS_view/job_seeker_profile.dart';

class NavJS extends StatefulWidget {
  const NavJS({super.key});
  @override
  State<NavJS> createState() => _NavJSState();
}

class _NavJSState extends State<NavJS> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    ProfileScreen(),
    HomePage(),
    AddPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: backgroundblack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            gap: 8,
            iconSize: 24,
            padding: EdgeInsets.all(16),
            duration: Duration(milliseconds: 300),
            tabBackgroundColor: Colors.grey.shade800,
            color: backgroundwhite,
            activeColor: backgroundwhite,
            tabs: [
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
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
