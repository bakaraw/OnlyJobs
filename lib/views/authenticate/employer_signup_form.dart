import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/constants.dart';

class ClientSignupForm extends StatefulWidget {
  const ClientSignupForm({super.key});

  @override
  _ClientSignupFormState createState() => _ClientSignupFormState();
}

class _ClientSignupFormState extends State<ClientSignupForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) => value != null && value.isEmpty
                    ? 'Please enter your email address'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value != null && value.isEmpty
                    ? 'Please enter a password'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) =>
                    value != null && value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerEmailAndPassword(
                        _emailController.text, _passwordController.text);

                    if (result == null) {
                      log('something went wrong');
                    }

                    await UserService(uid: result.uid).addEmployer(
                        _nameController.text,
                        _emailController.text,
                        'aeff',
                        'aesf');

                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: accent1,
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
