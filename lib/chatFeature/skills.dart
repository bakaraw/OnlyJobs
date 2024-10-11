import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../views/constants/constants.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

void showSkillsBottomSheet(String receiverUserId, BuildContext context) {
  showModalBottomSheet(
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
            return Center(child: Text('No skills found'));
          }

          List<dynamic> skills = snapshot.data!['skills'] ?? [];
          if (skills.isEmpty) {
            return Center(child: Text('No skills added'));
          }

          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skills:',
                  style: usernameStyle,
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: skills.map((skill) => ListTile(title: Text(skill), style: ListTileStyle.list,)).toList(),                  ),
                ),

              ],
            ),
          );
        },
      );
    },
  );
}
