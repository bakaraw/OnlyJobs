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
    //return Scaffold(
      //body: Container(
      //  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      //  child: Form(
      //    key: _formKey,
      //    child: Column(
      //      children: <Widget>[
      //        const SizedBox(
      //          height: 20,
      //        ),
      //        TextFormField(
      //          decoration: InputDecoration(
      //            labelText: 'Email'
      //          ),
      //          controller: emailctl,
      //          validator: (val) =>
      //              val == null || val.isEmpty ? 'Enter an email' : null,
      //        ),
      //        const SizedBox(
      //          height: 20,
      //        ),
      //        TextFormField(
      //          decoration: const InputDecoration(
      //            labelText: 'Password'
      //          ),
      //          controller: passordctl,
      //          obscureText: true,
      //          validator: (val) => val == null || val.length < 6
      //              ? 'Enter password 6+ long'
      //              : null,
      //        ),
      //        const SizedBox(
      //          height: 20,
      //        ),
      //        Text(
      //          error,
      //          style: const TextStyle(color: Colors.red, fontSize: 14),
      //        ),
      //        const SizedBox(
      //          height: 10,
      //        ),
      //        ElevatedButton(
      //            style: ElevatedButton.styleFrom(
      //              backgroundColor: Colors.pink,
      //            ),
      //            child: const Text(
      //              "Sign in",
      //              style: TextStyle(color: Colors.white),
      //            ),
      //            onPressed: () async {
      //              if (_formKey.currentState != null &&
      //                  _formKey.currentState!.validate()) {
      //                dynamic result = await _auth.signInWithEmailAndPassword(
      //                    emailctl.text, passordctl.text);
      //
      //                if (result == null) {
      //                  setState(() {
      //                    error = 'Invalid credentials';
      //                  });
      //                }
      //              }
      //            }),
      //        const SizedBox(
      //          height: 20,
      //        ),
      //        Row(
      //          mainAxisAlignment: MainAxisAlignment.center,
      //          children: [
      //            const Text("Don't have an account?"),
      //            TextButton(
      //              onPressed: () {
      //                widget.toggleView();
      //                Navigator.pushNamed(context, '/register');
      //              },
      //              child: const Text("Register"),
      //            )
      //          ],
      //        )
      //      ],
      //    ),
      //  ),
      //),
    //);
    return Scaffold();

  }
}
