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
    return Scaffold();
  }
}
