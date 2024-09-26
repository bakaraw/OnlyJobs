import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart'; // Ensure this is the correct path to your ChatPage

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final Stream<QuerySnapshot> userStream =
  FirebaseFirestore.instance.collection('User').snapshots(); // Use 'user' as the collection name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
              String uid = document.id; // Get the UID from the document ID

              return ListTile(
                title: Text(userData['name'] ?? 'No Name'), // Display user name
                subtitle: Text(userData['email'] ?? 'No Email'), // Display user email
                onTap: () {
                  // Navigate to ChatPage with the selected user's UID
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(user: uid), // Assuming ChatPage takes a user parameter
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
