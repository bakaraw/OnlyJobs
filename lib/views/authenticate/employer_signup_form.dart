import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/constants/loading.dart';

class ClientSignupForm extends StatefulWidget {
  @override
  _ClientSignupFormState createState() => _ClientSignupFormState();
}

class _ClientSignupFormState extends State<ClientSignupForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
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
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Please enter the Company Address'
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Please enter the Company Phone Number'
                          : null,
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
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
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
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.registerEmailAndPassword(
                              _emailController.text, _passwordController.text);

                          if (result == null) {
                            log('Error: Registration failed');
                            setState(() {
                              error = 'Registration failed';
                              loading = false;
                            });
                          } else {
                            await UserService(uid: result.openningUid)
                                .addUser(
                                    _nameController.text,
                                    null,
                                    null,
                                    _emailController.text,
                                    _phoneController.text,
                                    _addressController.text,
                                    false);

                            Navigator.pop(context);
                          }
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
