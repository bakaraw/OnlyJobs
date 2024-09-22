import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/sign_in.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}
