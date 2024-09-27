import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'dart:developer';
import 'package:only_job/services/user_service.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                validator: (val) => emptyFieldValidator(val, 'Enter name'),
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                validator: (val) => emptyFieldValidator(val, 'Enter gender'),
                decoration: InputDecoration(labelText: 'Gender'),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other'].map((String gender) {
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
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) =>
                    emptyFieldValidator(val, 'Enter date of birth'),
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? null
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) =>
                    emptyFieldValidator(val, 'Enter phone number'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => emptyFieldValidator(val, 'Enter address'),
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => emptyFieldValidator(val, 'Enter email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => val == null || val.length < 6
                    ? 'Password should be 6+ characters long'
                    : null,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) =>
                    val == null || val != _passwordController.text
                        ? 'Password does not match'
                        : null,
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              SizedBox(height: 20),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerEmailAndPassword(
                        _emailController.text, _passwordController.text);

                    if (result == null) {
                      setState(() {
                        error = 'Something went wrong in creating your account';
                      });
                    }
                    await UserService(uid: result.uid).addJobSeeker(_nameController.text, _selectedGender!, _selectedDate!, _emailController.text, _phoneController.text, _addressController.text);
                    
                    // pops this page
                    Navigator.pop(context);
                    // pops the employee_or_employer.dart
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? emptyFieldValidator(String? value, String msg) {
    return value == null || value.isEmpty ? msg : null;
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
