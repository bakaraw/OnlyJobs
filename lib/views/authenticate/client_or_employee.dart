import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/sign_up_form.dart';
import 'client_signup_form.dart';

class ClientOrEmployee extends StatelessWidget {
  const ClientOrEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Role'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignUpForm(),
                  ),
                );
              },
              child: Text('Employee'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClientSignupForm(),
                  ),
                );
              },
              child: Text('Employer'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
