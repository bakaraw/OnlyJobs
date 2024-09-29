import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/client_or_employee.dart';
import 'package:only_job/views/authenticate/register_or_login.dart';
import 'package:only_job/views/constants/constants.dart';
import 'dart:developer';
import 'package:only_job/services/auth.dart';
import 'package:only_job/views/constants/loading.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  late String errormessage;
  late bool isError;

  bool loading = false;

  @override
  void initState() {
    errormessage = "";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//Error Message
  void checkRegister(email, password) {
    setState(() {
      if (email == "") {
        errormessage = "Please input your email!";
        isError = true;
      } else if (password == "") {
        errormessage = "Please input your password!";
        isError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
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
              backgroundColor: primarycolor,
            ),
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  color: primarycolor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      largeSizedBox_W,
                      Image.asset(
                        'Logo.png',
                        height: 150,
                        width: 150,
                      ),
                      extraLargeSizedBox_W,
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: backgroundwhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            largeSizedBox_H,
                            Text(
                              "Login",
                              style: headingStyle,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Please enter your credentials to continue.",
                              style: bodyStyle,
                              textAlign: TextAlign.center,
                            ),
                            largeSizedBox_H,
                            TextFormField(
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Enter an email'
                                  : null,
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Email Address',
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email Address',
                              ),
                              onChanged: (value) {},
                            ),
                            largeSizedBox_H,
                            TextFormField(
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Enter password'
                                  : null,
                              controller: passwordcontroller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Password',
                              ),
                              onChanged: (value) {},
                              obscureText: true,
                            ),
                            largeSizedBox_H,
                            (isError)
                                ? Text(
                                    errormessage,
                                    style: errortxtstyle,
                                  )
                                : Container(),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  dynamic result = await AuthService()
                                      .signInWithEmailAndPassword(
                                    emailcontroller.text,
                                    passwordcontroller.text,
                                  );

                                  if (result == null) {
                                    setState(() {
                                      errormessage =
                                          'Invalid email or password';
                                      isError = true;
                                      loading = false;
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(50),
                                foregroundColor: Colors.white,
                                backgroundColor: accent1,
                              ),
                              child: Text('Sign In'),
                            ),
                            mediumSizedBox_H,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientOrEmployee(),
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
                              ],
                            ),
                            largeSizedBox_H,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
