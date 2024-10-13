import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:only_job/views/JS_view/job_seeker_home.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/JS_view/job_seeker_profile.dart';

import '../../chatFeature/main_chat_page.dart';

class NavJS extends StatefulWidget {
  const NavJS({super.key});
  @override
  State<NavJS> createState() => _NavJSState();
}

class _NavJSState extends State<NavJS> {
  int _currentIndex = 1;
  late List<Widget> _pages;

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProfileScreen(),
      HomePage(changePage: _changePage),
      MainChatPage(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      _pages[1] = HomePage(key: UniqueKey(), changePage: _changePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: backgroundblack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              _changePage(index);
            },
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
                icon: Icons.messenger_outline_rounded,
                text: 'Chat',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
