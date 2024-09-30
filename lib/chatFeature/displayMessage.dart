import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class DisplayMessage extends StatefulWidget {
  final String user;

   const DisplayMessage({super.key, required this.user});



  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {

  late final Stream<QuerySnapshot> messageStream;

  @override
  void initState() {
    super.initState();
   //Debugging
    print('Fetching messages for user: ${widget.user}');


    messageStream = FirebaseFirestore.instance
        .collection('User')  // Root collection
        .doc(widget.user)    // Document with user's uid
        .collection('messages')  // Subcollection 'messages'
        .orderBy('time')  // Ordering messages by time
        .snapshots();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages found"));
        }

        // Building the message list
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];
            Timestamp time = qds['time'];
            DateTime dateTime = time.toDate();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      title: Text(
                        qds['receiver'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        qds['message'],
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                  Text(
                    '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
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