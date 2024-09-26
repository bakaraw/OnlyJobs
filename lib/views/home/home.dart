import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import '../../chatFeature/chat_page.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Sign out"),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Chat Bubble'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MainChatPage(User: currentUserId,), // Pass the user ID
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
