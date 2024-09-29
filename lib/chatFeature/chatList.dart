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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> contacts = [];
  Stream<QuerySnapshot>? contactsStream;
  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    String currentUserId = auth.currentUser!.uid;

    DocumentSnapshot userDoc = await firestore.collection('User').doc(currentUserId).get();

    if (userDoc.exists) {
      List<dynamic> contactList = userDoc.get('contacts') ?? [];
      contacts = List<String>.from(contactList);

      if (contacts.isNotEmpty) {
        contactsStream = firestore
            .collection('User')
            .where(FieldPath.documentId, whereIn: contacts)
            .snapshots();
      }

      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Contacts'),
      ),
      body: contactsStream == null
          ? Center(child: Text('No people added yet'))
          : StreamBuilder<QuerySnapshot>(
        stream: contactsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No contacts found'));
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