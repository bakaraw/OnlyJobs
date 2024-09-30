import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chatFeature/userSearch.dart';
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
        setState(() {
          contactsStream = firestore
            .collection('User')
            .where(FieldPath.documentId, whereIn: contacts)
            .snapshots();

      } );
            } else {
        setState(() {
          contactsStream = null;
        });
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: UserSearchDelegate(),
              );

              if (result != null) {
                await fetchContacts();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('User').doc(auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No contacts found'));
          }

          List<dynamic> contactList = snapshot.data!.get('contacts') ?? [];
          contacts = List<String>.from(contactList);

          if (contacts.isEmpty) {
            return Center(child: Text('No contacts found'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('User')
                .where(FieldPath.documentId, whereIn: contacts)
                .snapshots(),
            builder: (context, contactSnapshot) {
              if (contactSnapshot.hasError) {
                return Center(child: Text("An error occurred"));
              }
              if (contactSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Loading());
              }

              if (contactSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No contacts found'));
              }

              return ListView(
                children: contactSnapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
                  String uid = document.id;

                  return ListTile(
                    title: Text(userData['name'] ?? 'No Name'),
                    subtitle: Text(userData['email'] ?? 'No Email'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(user: {'uid': uid, 'name': userData['name']}),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}