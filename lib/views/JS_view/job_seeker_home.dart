import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'Logo.png',
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildProfileModal(context);
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      'assets/profile_picture.png'), // Replace with your profile image
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Chat Page',
              style: TextStyle(
                fontSize: 24,
                color: backgroundwhite, // Text color matching the theme
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileModal(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 60, // Position the modal below the AppBar area
          right: 10, // Align it to the right
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300, // Set the width of the modal
              decoration: BoxDecoration(
                color: backgroundwhite, // Background color of the modal
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe', // Replace with actual full name
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Education: Bachelor of Science in Computer Science', // Replace with actual education
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Skills:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '- Flutter Development\n- Firebase\n- UI/UX Design', // Replace with actual skills
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the modal
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
