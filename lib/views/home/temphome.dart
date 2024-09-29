import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';

import '../../chatFeature/mainChatPage.dart';
import 'package:provider/provider.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return StreamBuilder<UserData>(

      stream: UserService(uid: user!.uid!).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
            ),
            body: Column(
              children: [
                if (user != null)
                  ElevatedButton(
                    child: Text(userData.name!),
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
                        builder: (context) => MainChatPage(), // Pass the user ID
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
