import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/introduction.dart';
import 'package:only_job/views/authenticate/login.dart';
import 'package:only_job/views/authenticate/register_or_login.dart';
import 'package:only_job/views/authenticate/sign_up_form.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/JS_view/Nav_JS.dart';
import 'package:only_job/JS_view/profileJS.dart';
import 'package:only_job/views/authenticate/employer_signup_form.dart';

class ClientOrEmployee extends StatelessWidget {
  const ClientOrEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RegisterLogin(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: accent1,
          ),
        ),
      ),
      backgroundColor: primarycolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Choose your role',
              style: headingStyle_white,
            ),
            extraLargeSizedBox_H,
            extraLargeSizedBox_H,
            extraLargeSizedBox_H,
            Card(
              color: backgroundwhite,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 150,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NavJS(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: accent1,
                        ),
                        child: Text('Employee'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            mediumSizedBox_H,
            Card(
              color: backgroundwhite,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 150,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClientSignupForm(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: accent1,
                        ),
                        child: Text('Employer'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have an Account? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: accent1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                largeSizedBox_H,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
