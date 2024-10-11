import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:only_job/views/JS_view/job_seeker_home.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/JS_view/job_seeker_profile.dart';

import '../../chatFeature/mainChatPage.dart';

class NavJS extends StatefulWidget {
  const NavJS({super.key});
  @override
  State<NavJS> createState() => _NavJSState();
}

class _NavJSState extends State<NavJS> {
  int _currentIndex = 1;
  late PageController _pageController;

  final List<Widget> _pages = [
    ProfileScreen(),
    HomePage(),
    MainChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
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
                icon: Icons.messenger_outline_rounded,
                text: 'Chat',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });

              _pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}


