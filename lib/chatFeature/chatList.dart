import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chatFeature/userSearch.dart';
import '../models/message.dart';
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

    DocumentSnapshot userDoc = await firestore.collection('User').doc(
        currentUserId).get();

    if (userDoc.exists) {
      List<dynamic> contactList = userDoc.get('contacts') ?? [];
      contacts = List<String>.from(contactList);

      if (contacts.isNotEmpty) {
        setState(() {
          contactsStream = firestore
              .collection('User')
              .where(FieldPath.documentId, whereIn: contacts)
              .snapshots();
        });
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
        title: Text('Search People'),
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
        stream: firestore.collection('User')
            .doc(auth.currentUser!.uid)
            .snapshots(),
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
                children: contactSnapshot.data!.docs.map((
                    DocumentSnapshot document) {
                  Map<String, dynamic> userData = document.data()! as Map<
                      String,
                      dynamic>;
                  String uid = document.id;

                  return ListTile(
                    title: Text(userData['name'] ?? 'No Name'),
                    subtitle: Text(userData['email'] ?? 'No Email'),
                    onTap: () async {
                      String currentUserId = auth.currentUser!.uid;
                      DocumentReference currentUserDoc = firestore.collection(
                          'User').doc(currentUserId);

                      // Update the contacts list
                      await currentUserDoc.update({
                        'contacts': FieldValue.arrayUnion([uid])
                      });

                      // Show dialog for accepting or rejecting message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Incoming Message"),
                            content: Text(
                                "You have a new message from ${userData['name']}. Do you accept?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await _acceptMessage();
                                  // Navigate to ChatPage after accepting
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(user: {
                                        'uid': uid,
                                        'name': userData['name']
                                      }),
                                    ),
                                  );
                                },
                                child: Text("Accept"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _rejectMessage();
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text("Reject"),
                              ),
                            ],
                          );
                        },
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


  Future<void> _acceptMessage(Message message) async {
    String currentUserId = auth.currentUser!.uid;

    // Update Firestore to mark the message as accepted
    await firestore
        .collection('User')
        .doc(currentUserId)
        .collection('messages')
        .doc(message.receiver)
        .collection('chatMessages')
        .doc(message.message)
        .update({'accepted': true});
  }

  Future<void> _rejectMessage(Message message) async {
    String currentUserId = auth.currentUser!.uid;

    // Update Firestore to mark the message as rejected
    await firestore
        .collection('User')
        .doc(currentUserId)
        .collection('messages')
        .doc(message.receiver) // Adjust based on your structure
        .collection('chatMessages')
        .doc(message.message) // Ensure you have a unique messageId
        .update({'accepted': false});
  }
}