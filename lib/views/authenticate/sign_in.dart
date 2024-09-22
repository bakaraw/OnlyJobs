import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'dart:developer';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: ElevatedButton(
          child: const Text("Sign in Anonymously"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              log('error signing in');
            } else {
              log('signed in');
              log(result.uid);
            }
          },
        ),
      ),
    );
  }
}
