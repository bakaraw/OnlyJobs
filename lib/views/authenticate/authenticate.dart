import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/login.dart';
import 'package:only_job/views/authenticate/sign_in.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: image),
            // Image(image: image),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create New Account'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
