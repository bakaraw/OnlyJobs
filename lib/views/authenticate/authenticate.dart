import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/login.dart';
import 'package:only_job/views/authenticate/sign_in.dart';
import 'package:only_job/views/authenticate/client_or_employee.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClientOrEmployee(),
                  ),
                );
              },
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
