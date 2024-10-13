import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:only_job/views/authenticate/client_or_employee.dart';
import 'package:only_job/views/authenticate/login.dart';
import 'package:only_job/views/constants/constants.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<RegisterLogin> createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  int _pageIndex = 0;

  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pageIndex == 1) {
      return ClientOrEmployee(changePage: _changePage);
    } else if (_pageIndex == 2) {
      return Login(changePage: _changePage);
    } else {
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
                  'assets/Logo.png',
                  height: 250,
                  width: 250,
                ),
                Image.asset(
                  'assets/BrandingName.png',
                  width: 150,
                ),
                largeSizedBox_H,
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _changePage(1);
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
                    _changePage(2);
                  },
                  child: Text(
                    "Sign In",
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
}

//class RegisterLogin extends StatelessWidget {
//  const RegisterLogin({super.key});
//
//}
