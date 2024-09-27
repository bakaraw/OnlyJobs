import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:only_job/views/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Allows user to pick image from the gallery
  Future<void> PickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = pickedFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: _profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            File(_profileImage!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: PickImage, // Call the image picker
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: accent1,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Account Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      // Full Name
                      _buildTextField("Full Name", "Enter your full name"),
                      const SizedBox(height: 10),

                      // Gender
                      _buildTextField("Gender", "Select your gender"),
                      const SizedBox(height: 10),

                      // Birthdate
                      _buildTextField("Birthdate", "Select your birthdate"),
                      const SizedBox(height: 10),

                      // Phone Number
                      _buildTextField(
                          "Phone Number", "Enter your phone number"),
                      const SizedBox(height: 10),

                      // Address
                      _buildTextField("Address", "Enter your address"),
                      const SizedBox(height: 10),

                      // Email Address
                      _buildTextField("Email Address", "Enter your email"),
                      const SizedBox(height: 10),

                      // Password Field
                      _buildPasswordField("Password", "Enter your password"),
                      const SizedBox(height: 20),

                      // Buttons
                      Column(
                        children: [
                          SizedBox(
                            height: 20, // Height margin before the buttons
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement save functionality
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                              foregroundColor: Colors.white,
                              backgroundColor: accent1,
                            ),
                            child: Text("Save"),
                          ),
                          const SizedBox(
                              height: 20), // Space between the buttons
                          ElevatedButton(
                            onPressed: () {
                              // Implement logout functionality
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Get the users info and paste it in hintt

  // Helper method for text fields
  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for password field
  Widget _buildPasswordField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: InputBorder.none,
            prefixIcon: Icon(Icons.lock),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
