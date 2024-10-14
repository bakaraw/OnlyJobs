import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

void showProfileBottomSheet(String receiverUserId, BuildContext context) {
  showModalBottomSheet(
    backgroundColor: primarycolor,
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
          String profilePicture = snapshot.data!['profile_picture'] ?? '';
          String address = snapshot.data!['address'] ?? 'No address available';
          String email = snapshot.data!['email'] ?? 'No email available';
          String phone = snapshot.data!['phone'] ?? 'No contact number available';

          return Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity, // Fill the width of the screen
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Company Details", style: usernameStylewithSecondaryColor),
                  SizedBox(height: 16),
                  profilePicture.isNotEmpty
                      ? Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profilePicture),
                    ),
                  )
                      : Center(
                    child: CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person),
                    ),
                  ),
                   SizedBox(height: 16),
                  Text('Name: $name', style: usernameStylewithSecondaryColor),
                  SizedBox(height: 16),
                  Text('Address: $address', style: usernameStylewithSecondaryColor),
                  SizedBox(height: 16),
                  Text('Email: $email', style: usernameStylewithSecondaryColor),
                  SizedBox(height: 16),
                  Text('Contact Number: $phone', style: usernameStylewithSecondaryColor),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
