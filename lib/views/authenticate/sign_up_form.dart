import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/constants/loading.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  String error = '';

  @override
  Widget build(BuildContext context) {
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
                  height: double.infinity,
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
                                "Sign Up",
                                style: headingStyle,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please fill in the details to register.",
                                style: bodyStyle,
                                textAlign: TextAlign.center,
                              ),
                              largeSizedBox_H,
                              // Full Name Field
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Full Name',
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Full Name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              largeSizedBox_H,
                              // Gender Field
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Gender',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                value: _selectedGender,
                                items: ['Male', 'Female', 'Other']
                                    .map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select your gender'
                                    : null,
                              ),
                              largeSizedBox_H,
                              // Date of Birth Field
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Date of Birth',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                controller: TextEditingController(
                                  text: _selectedDate == null
                                      ? null
                                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please select your date of birth'
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
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
                                  hintText: 'Enter Address',
                                  prefixIcon: Icon(Icons.location_on),
                                  labelText: 'Address',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.length < 6) {
                                    return 'Password should be at least 6 characters';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
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
                                              _selectedGender,
                                              _selectedDate,
                                              _emailController.text,
                                              _phoneController.text,
                                              _addressController.text,
                                              true);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
