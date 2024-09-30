import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class DisplayMessage extends StatefulWidget {
  final String user;

   DisplayMessage({super.key, required this.user});



  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}


final AuthService authService = AuthService();
String? currentUserName;



class _DisplayMessageState extends State<DisplayMessage> {

  late final Stream<QuerySnapshot> messageStream;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
    messageStream = FirebaseFirestore.instance
        .collection('User') // Root collection
        .doc(currentUserName)    // Document with user's uid
        .collection('messages') // Subcollection 'messages'
        .orderBy('time') // Ordering messages by time
        .snapshots();
  }

  void fetchCurrentUserName() async {
    currentUserName = await authService.getCurrentUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Check if there are no messages
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages found"));
        }

        // Building the message list
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];

            Timestamp time = qds['time'];
            DateTime dateTime = time.toDate();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align messages to the start
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      title: Text(
                        qds['senderName'], // Display the sender's name
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              qds['message'], // Display the message content
                              softWrap: true,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}', // Format time for better readability
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}