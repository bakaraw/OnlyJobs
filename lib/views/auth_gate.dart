import 'package:flutter/material.dart';
import 'package:only_job/views/home/home.dart';
import 'package:only_job/views/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:only_job/models/user.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user != null) {
      return Home();
    } else {
      return Authenticate();
    }
  }
}
