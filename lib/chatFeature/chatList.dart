import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/constants/loading.dart';
import 'chat_page.dart';
class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {


  final Stream<QuerySnapshot> userStream =
  FirebaseFirestore.instance.collection('ChatUser').snapshots();

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
            return Center(child: Loading());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
              String uid = document.id;

              return ListTile(
                title: Text(userData['name'] ?? 'No Name'),
                subtitle: Text(userData['email'] ?? 'No Email'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          user: userData,
                        ),
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
