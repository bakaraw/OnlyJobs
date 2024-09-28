import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';

import '../../chatFeature/mainChatPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  void _loadCurrentUserId() {
    setState(() {
      currentUserId = _auth.getCurrentUserId() ?? ''; // Assign user ID or an empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
           children: [
           ElevatedButton(
                  child: const Text("Sign out"),
                    onPressed: () async {
                    _auth.signOut();
                    },
                    ),
               ElevatedButton(
                  child: const Text("Go to Chat"),
                  onPressed: () {
                    Navigator.push(
                    context,
                  MaterialPageRoute(
                  builder: (context) => MainChatPage(User: currentUserId), // Pass the user ID
          ),
          );
      },
      ),
    ],
    ),
    );
  }

  }