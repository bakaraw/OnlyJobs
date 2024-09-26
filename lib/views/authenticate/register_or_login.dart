import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:only_job/views/authenticate/client_or_employee.dart';
import 'package:only_job/views/authenticate/login.dart';
import 'package:only_job/views/constants/constants.dart';

class RegisterLogin extends StatelessWidget {
  const RegisterLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              extraLargeSizedBox_H,
              Image.asset(
                'Logo.png',
                height: 250,
                width: 250,
              ),
              Image.asset(
                'BrandingName.png',
                width: 150,
              ),
              largeSizedBox_H,
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ClientOrEmployee(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  foregroundColor: Colors.white,
                  backgroundColor: accent1,
                ),
                child: Text('Create New Account'),
              ),
              mediumSizedBox_H,
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: accent1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              extraLargeSizedBox_H,
            ],
          ),
        ),
      ),
    );
  }
}
