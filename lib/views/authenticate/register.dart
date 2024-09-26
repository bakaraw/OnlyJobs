import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'dart:developer';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailctl = TextEditingController();
  TextEditingController passordctl = TextEditingController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
                controller: emailctl,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter an email' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
                controller: passordctl,
                obscureText: true,
                validator: (val) => val == null || val.length < 6
                    ? 'Enter password 6+ long'
                    : null,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {

                    dynamic result = await _auth.registerEmailAndPassword(
                        emailctl.text, passordctl.text);

                    if (result == null) {
                      setState(() {
                        error = 'Invalid email';
                      });
                    }
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already registered?"),
                  TextButton(
                    onPressed: () {
                      widget.toggleView();
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Sign in"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
