import 'package:flutter/material.dart';

class EditContactInfoPage extends StatefulWidget {
  final Map<String, String> contactInfo;

  const EditContactInfoPage({Key? key, required this.contactInfo})
      : super(key: key);

  @override
  _EditContactInfoPageState createState() => _EditContactInfoPageState();
}

class _EditContactInfoPageState extends State<EditContactInfoPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contactInfo['name']);
    phoneController = TextEditingController(text: widget.contactInfo['phone']);
    addressController =
        TextEditingController(text: widget.contactInfo['address']);
    emailController = TextEditingController(text: widget.contactInfo['email']);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Save the updated contact info and return it to the previous page
  void saveContactInfo() {
    Navigator.pop(context, {
      'name': nameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'email': emailController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveContactInfo,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
