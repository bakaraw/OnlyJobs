import 'package:flutter/material.dart';
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
    // Get the available height from the screen
    final double screenHeight = MediaQuery.of(context).size.height;

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                // Background and Logo
                Container(
                  height: screenHeight, // Full screen height
                  color: primarycolor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      largeSizedBox_W,
                      Image.asset(
                        'assets/Logo.png',
                        height: 150,
                        width: 150,
                      ),
                      extraLargeSizedBox_W,
                    ],
                  ),
                ),
                // Scrollable Signup form section
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Container(
                    height: screenHeight -
                        150, // Ensures it fills the remaining height
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: backgroundwhite,
                    ),
                    child: SingleChildScrollView(
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
                                "Client Sign Up",
                                style: headingStyle,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please fill in the details to register.",
                                style: bodyStyle,
                                textAlign: TextAlign.center,
                              ),
                              largeSizedBox_H,
                              // Company Name Field
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Company Name',
                                  prefixIcon: Icon(Icons.business),
                                  labelText: 'Company Name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your company name';
                                  }
                                  return null;
                                },
                              ),
                              largeSizedBox_H,
                              // Address Field
                              TextFormField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Company Address',
                                  prefixIcon: Icon(Icons.location_on),
                                  labelText: 'Address',
                                ),
                                validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Please enter the company address'
                                        : null,
                              ),
                              largeSizedBox_H,
                              // Phone Number Field
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Phone Number',
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'Phone Number',
                                ),
                                validator: (value) => value != null &&
                                        value.isEmpty
                                    ? 'Please enter the company phone number'
                                    : null,
                              ),
                              largeSizedBox_H,
                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Email Address',
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email Address',
                                ),
                                validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Please enter your email address'
                                        : null,
                              ),
                              largeSizedBox_H,
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Password',
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: 'Password',
                                ),
                                validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Please enter a password'
                                        : null,
                              ),
                              largeSizedBox_H,
                              // Confirm Password Field
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: 'Confirm Password',
                                ),
                                validator: (value) => value != null &&
                                        value != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                              ),
                              largeSizedBox_H,
                              // Submit Button
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text);

                                    if (result == null) {
                                      setState(() {
                                        error = 'Registration failed';
                                        loading = false;
                                      });
                                    } else {
                                      await UserService(uid: result.uid)
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
                                  minimumSize: Size.fromHeight(50),
                                  foregroundColor: Colors.white,
                                  backgroundColor: accent1,
                                ),
                                child: Text('Sign Up'),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
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
