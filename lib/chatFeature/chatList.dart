import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chatFeature/userSearch.dart';
import '../views/constants/loading.dart';
import 'chat_page.dart';

class UserListPage extends StatefulWidget {
  final String user;
  final String receiverUserId;

  const UserListPage({super.key, required this.user, required this.receiverUserId});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<String> contacts = [];
  List<String> pendingContacts = [];
  Stream<QuerySnapshot>? contactsStream;
  Stream<QuerySnapshot>? pendingStream;

  @override
  void initState() {
    super.initState();
    fetchContactsAndPending();
  }

  // Fetch both contacts and pending requests, with null handling
  Future<void> fetchContactsAndPending() async {
    String currentUserId = auth.currentUser!.uid;

    DocumentSnapshot userDoc = await firestore.collection('User').doc(currentUserId).get();

    if (userDoc.exists) {
      // Safely get contacts and pending requests
      // Safely get contacts and pending requests
      List<dynamic> contactList = (userDoc.data() as Map<String, dynamic>?)?['contacts'] ?? [];  // Null-safe access
      List<dynamic> pendingList = (userDoc.data() as Map<String, dynamic>?)?['pending'] ?? [];

      contacts = List<String>.from(contactList);
      pendingContacts = List<String>.from(pendingList);

      // Update contact and pending streams, with null checks
      if (contacts.isNotEmpty) {
        setState(() {
          contactsStream = firestore.collection('User')
              .where(FieldPath.documentId, whereIn: contacts)
              .snapshots();
        });
      } else {
        setState(() {
          contactsStream = null; // Handle no contacts
        });
      }

      if (pendingContacts.isNotEmpty) {
        setState(() {
          pendingStream = firestore.collection('User')
              .where(FieldPath.documentId, whereIn: pendingContacts)
              .snapshots();
        });
      } else {
        setState(() {
          pendingStream = null; // Handle no pending contacts
        });
      }
    }
  }

  // Accept a pending request (move from pending to contacts)
  Future<void> acceptContact(String uid) async {
    String currentUserId = auth.currentUser!.uid;

    try {
      await firestore.collection('User').doc(currentUserId).update({
        'pending': FieldValue.arrayRemove([uid]),
        'contacts': FieldValue.arrayUnion([uid]), // Add to contacts
      });

      setState(() {
        pendingContacts.remove(uid); // Update local state
        contacts.add(uid); // Move to contacts
      });

      await fetchContactsAndPending(); // Refresh the display
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting contact: $e')),
      );
    }
  }

  // Reject a pending request (remove from pending)
  Future<void> rejectContact(String uid) async {
    String currentUserId = auth.currentUser!.uid;

    try {
      await firestore.collection('User').doc(currentUserId).update({
        'pending': FieldValue.arrayRemove([uid]), // Remove from pending
      });

      setState(() {
        pendingContacts.remove(uid); // Update local state
      });

      await fetchContactsAndPending(); // Refresh the display
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting contact: $e')),
      );
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
              final result = await showSearch(context: context, delegate: UserSearchDelegate());
              if (result != null) {
                await fetchContactsAndPending(); // To refresh the contact list display
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pending contacts section
            if (pendingContacts.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    pendingStream != null
                        ? StreamBuilder<QuerySnapshot>(
                      stream: pendingStream,
                      builder: (context, pendingSnapshot) {
                        if (pendingSnapshot.hasError) {
                          return Center(child: Text("Error loading pending requests"));
                        }
                        if (pendingSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: Loading());
                        }

                        if (pendingSnapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No pending requests.'));
                        }

                        return Column(
                          children: pendingSnapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic>? userData = document.data() as Map<String, dynamic>?;
                            String uid = document.id;

                            return ListTile(
                              title: Text(userData?['name'] ?? 'No Name'),  // Null-safe access
                              subtitle: Text(userData?['email'] ?? 'No Email'),  // Null-safe access
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.check, color: Colors.green),
                                    onPressed: () => acceptContact(uid),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () => rejectContact(uid),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    )
                        : Center(child: Text('No pending requests.')),
                  ],
                ),
              ),

            Divider(),

            // Contacts section
            contactsStream != null
                ? StreamBuilder<QuerySnapshot>(
              stream: contactsStream,
              builder: (context, contactSnapshot) {
                if (contactSnapshot.hasError) {
                  return Center(child: Text("An error occurred"));
                }
                if (contactSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Loading());
                }

                if (contactSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No contacts found. You can add users through search.'));
                }

                return ListView(
                  shrinkWrap: true, // Adjust the list to fit content
                  children: contactSnapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic>? userData = document.data() as Map<String, dynamic>?;  // Null-safe access
                    String uid = document.id;

                    return ListTile(
                      title: Text(userData?['name'] ?? 'No Name'),  // Null-safe access
                      subtitle: Text(userData?['email'] ?? 'No Email'),  // Null-safe access
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(user: {'uid': uid, 'name': userData?['name']}), // Navigate to ChatPage
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            )
                : Center(child: Text('No contacts found.')),
          ],
        ),
      ),
    );
  }
}
