import 'package:flutter/material.dart';
import 'package:only_job/models/user.dart';
import 'package:intl/intl.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/services/auth.dart';

class EditContactInfoPage extends StatefulWidget {
  final UserData userData;

  EditContactInfoPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _EditContactInfoPageState createState() => _EditContactInfoPageState();
}

class _EditContactInfoPageState extends State<EditContactInfoPage> {
  late AuthService _auth;
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _birthdateController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _emailController;
  late String _initialEmail;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    String formattedBirthdate = widget.userData.birthDate != null
        ? DateFormat('MMMM d, yyyy').format(widget.userData.birthDate!)
        : '';

    // Initialize controllers with current contact information
    _nameController = TextEditingController(text: widget.userData.name);
    _genderController = TextEditingController(text: widget.userData.gender);
    _birthdateController = TextEditingController(text: formattedBirthdate);
    _phoneController = TextEditingController(text: widget.userData.phone);
    _addressController = TextEditingController(text: widget.userData.address);
    _websiteController = TextEditingController(text: widget.userData.website);
    _emailController = TextEditingController(text: widget.userData.email);
    _initialEmail = widget.userData.email!;
    _auth = AuthService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveContactInfo() async {
    // Collect updated contact information
    if (_formKey.currentState == null) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await UserService(uid: widget.userData.uid!).updateUserData(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _addressController.text,
    );

    if (_websiteController.text != null && _websiteController.text.isNotEmpty) {
      await UserService(uid: widget.userData.uid!)
          .updateWebsite(_websiteController.text);
    }

    if (_initialEmail != _emailController.text) {
      await _auth.updateEmail(_emailController.text);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact Information'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContactInfo, // Save updated contact info
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Full Name', _nameController),
              SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneController,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 16),
              _buildTextField('Address', _addressController),
              SizedBox(height: 16),
              _buildTextField('Website (optional)', _websiteController,
                  validator: (value) {
                return null;
              }),
              SizedBox(height: 16),
              _buildTextField('Email', _emailController,
                  keyboardType: TextInputType.emailAddress),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create text fields for each contact information field
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
    );
  }
}
