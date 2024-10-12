import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String fullName = 'John Doe';
  final String gender = 'Male';
  final String birthdate = 'January 1, 1990';
  final String phoneNumber = '+1 (555) 555-5555';
  final String address = '123 Main St, City, Country';
  final String email = 'john.doe@example.com';
  final String website = 'www.johndoe.com';
  final String education = 'B.Sc. Computer Science';
  final String certification = 'Certified Flutter Developer';
  final List<String> skills = ['Flutter', 'Dart', 'Firebase', 'UI/UX Design'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        titleTextStyle: headingStyle_white,
        backgroundColor: primarycolor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Action for "Send a Message" button
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message Sent!')),
                );
              },
              child: Center(
                child: Text(
                  'Send a Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Personal Information'),
            _buildProfileDetail('Full Name', fullName),
            _buildProfileDetail('Gender', gender),
            _buildProfileDetail('Birthdate', birthdate),
            _buildProfileDetail('Phone Number', phoneNumber),
            _buildProfileDetail('Address', address),
            SizedBox(height: 20),
            _buildSectionHeader('Contact Details'),
            _buildProfileDetail('Email', email),
            _buildProfileDetail('Website', website),
            SizedBox(height: 20),
            _buildSectionHeader('Education & Skills'),
            _buildProfileDetail('Education', education),
            _buildProfileDetail('Certification', certification),
            _buildProfileDetail('Skills', skills.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
