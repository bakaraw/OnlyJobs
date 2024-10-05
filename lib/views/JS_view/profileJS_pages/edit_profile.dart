import 'package:flutter/material.dart';

class EditContactInfoPage extends StatefulWidget {
  final Map<String, String> contactInfo;

  const EditContactInfoPage({required this.contactInfo, Key? key})
      : super(key: key);

  @override
  _EditContactInfoPageState createState() => _EditContactInfoPageState();
}

class _EditContactInfoPageState extends State<EditContactInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _birthdateController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current contact information
    _nameController = TextEditingController(text: widget.contactInfo['name']);
    _genderController =
        TextEditingController(text: widget.contactInfo['gender']);
    _birthdateController =
        TextEditingController(text: widget.contactInfo['birthdate']);
    _phoneController = TextEditingController(text: widget.contactInfo['phone']);
    _addressController =
        TextEditingController(text: widget.contactInfo['address']);
    _emailController = TextEditingController(text: widget.contactInfo['email']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveContactInfo() {
    // Collect updated contact information
    final updatedContactInfo = {
      'name': _nameController.text,
      'gender': _genderController.text,
      'birthdate': _birthdateController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'email': _emailController.text,
    };

    // Return updated contact information to the previous screen
    Navigator.pop(context, updatedContactInfo);
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
        child: ListView(
          children: [
            _buildTextField('Full Name', _nameController),
            SizedBox(height: 16),
            _buildTextField('Gender', _genderController),
            SizedBox(height: 16),
            _buildTextField('Birthdate', _birthdateController),
            SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController,
                keyboardType: TextInputType.phone),
            SizedBox(height: 16),
            _buildTextField('Address', _addressController),
            SizedBox(height: 16),
            _buildTextField('Email', _emailController,
                keyboardType: TextInputType.emailAddress),
          ],
        ),
      ),
    );
  }

  // Helper method to create text fields for each contact information field
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
