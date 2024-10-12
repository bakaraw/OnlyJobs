import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'chat_list.dart';

class MainChatPage extends StatefulWidget {

  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page', style: usernameStylewithSecondaryColor,
        ),
       // leading: Image.asset('assets/Logo.png'),
        centerTitle: true,
        backgroundColor: primarycolor,

      ),
      body:UserListPage(user: '', receiverUserId: '',),


    );
  }
}
