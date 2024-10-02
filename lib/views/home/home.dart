import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import '../../chatFeature/mainChatPage.dart';
import 'package:provider/provider.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/loading.dart';
// import 'package:only_job/views/home/homepageJS.dart';
import 'package:only_job/views/home/employer_homepage.dart';
import 'package:only_job/views/JS_view/job_seeker_nav.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.uid});
  String uid;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: UserService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          if (userData.isJobSeeker!) {
            return NavJS();
          }
          return ClientHomePage();
        }

        return const Loading();
      },
    );
  }
}
