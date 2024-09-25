import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'dart:developer';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // controller for the text field
  TextEditingController emailctl = TextEditingController();
  TextEditingController passordctl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {

  }
}
