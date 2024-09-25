import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/sign_in.dart';
import 'package:only_job/views/authenticate/client_or_employee.dart';

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
              onPressed: () {},
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
