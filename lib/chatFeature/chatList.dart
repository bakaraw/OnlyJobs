import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chatFeature/userSearch.dart';
import '../models/message.dart';
import '../views/constants/loading.dart';
import 'chat_page.dart';
class UserListPage extends StatefulWidget {
  final String user; // Receiver's name
  final String receiverUserId; // Receiver's user ID

  const UserListPage({super.key, required this.user, required this.receiverUserId});

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
                children: contactSnapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
                  String uid = document.id;

                  return ListTile(
                    title: Text(userData['name'] ?? 'No Name'),
                    subtitle: Text(userData['email'] ?? 'No Email'),
                    onTap: () async {
                      String currentUserId = auth.currentUser!.uid;
                      DocumentReference currentUserDoc = firestore.collection('User').doc(currentUserId);

                      // Check if the user is already in contacts
                      DocumentSnapshot currentUserSnapshot = await currentUserDoc.get();
                      List<dynamic> contacts = currentUserSnapshot.get('contacts') ?? [];

                      if (!contacts.contains(uid)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(user: {
                              'uid': uid,
                              'name': userData['name']
                            }),
                          ),
                        );
                      } else {
                        Message newMessage = Message(
                          message: 'Sample message', // Replace with actual message
                          time: DateTime.now(),
                          senderName: 'Sender', // Replace with actual sender name
                          receiver: userData['name'],
                        );
                        await _showAcceptRejectDialog(context, newMessage, uid);
                      }
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

  Future<void> _rejectMessage(Message message, String uid) async {
    String currentUserId = auth.currentUser!.uid;

    // Remove the contact from the current user's contact list
    await firestore
        .collection('User')
        .doc(currentUserId)
        .update({
      'contacts': FieldValue.arrayRemove([uid])
    });

    // Update Firestore to mark the message as rejected
    await firestore
        .collection('User')
        .doc(currentUserId)
        .collection('messages')
        .doc(widget.receiverUserId)
        .collection('chatMessages')
        .where('message', isEqualTo: message.message)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'accepted': false});
      }
    });
  }
  Future<void> _acceptMessage(Message message, String uid) async {
    String currentUserId = auth.currentUser!.uid;

    // Add the contact to the current user's contact list
    await firestore
        .collection('User')
        .doc(currentUserId)
        .update({
      'contacts': FieldValue.arrayUnion([uid])
    });

    // Update Firestore to mark the message as accepted
    await firestore
        .collection('User')
        .doc(currentUserId)
        .collection('messages')
        .doc(widget.receiverUserId)
        .collection('chatMessages')
        .where('message', isEqualTo: message.message)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'accepted': true});
      }
    });
  }


  Future<void> _showAcceptRejectDialog(BuildContext context, Message message, String uid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accept or Reject Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to accept or reject this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Reject'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(user: {
                      'uid': uid,
                      'name': message.receiver
                    }),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(user: {
                      'uid': uid,
                      'name': message.receiver
                    }),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}