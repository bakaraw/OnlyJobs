import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

void showSkillsBottomSheet(String receiverUserId, BuildContext context) {
  showModalBottomSheet(
    backgroundColor: secondarycolor,
    context: context,
    builder: (context) {
      return FutureBuilder<DocumentSnapshot>(
        future: firebaseFirestore.collection('User').doc(receiverUserId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No Profile found'));
          }

          // Extract user data
          String name = snapshot.data!['name'] ?? 'No name available';
          String email = snapshot.data!['email'] ?? 'No email available';
          String profilePictureUrl = snapshot.data!['profile_picture'] ?? ''; // Add this for profile picture

          // Check for skills field (can be empty or missing)
          List<dynamic> skills = snapshot.data!['skills'] ?? [];

          return Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity, // Fill the width of the screen
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display user profile picture
                  profilePictureUrl.isNotEmpty
                      ? Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profilePictureUrl),
                    ),
                  )
                      : Center(
                    child: CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Display name and email
                  Text('Name: $name', style: usernameStyle),
                  SizedBox(height: 8),
                  Text('Email: $email', style: usernameStyle),
                  SizedBox(height: 16),
                  Divider(),
                  // Display skills
                  Text("Skills", style: headingStyle),
                  SizedBox(height: 8),
                  skills.isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: skills.map((skill) => Text('- $skill', style: usernameStyle)).toList(),
                  )
                      : Text('No skills available', style: usernameStyle),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
