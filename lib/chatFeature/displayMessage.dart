import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class DisplayMessage extends StatefulWidget {
  final String user; // Receiver's name
  final String receiverUserId; // Receiver's user ID

  const DisplayMessage({super.key, required this.user, required this.receiverUserId});

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  late final Stream<List<Message>> messageStream;

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  void _getMessages() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;



    messageStream = FirebaseFirestore.instance
        .collection('User')
        .doc(currentUserId)
        .collection('messages')
        .doc(widget.receiverUserId)
        .collection('chatMessages')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Check if there are no messages
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("No messages found"));
        }

        // Building the message list
        return ListView.builder(
          itemCount: snapshot.data!.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Message message = snapshot.data![index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        message.senderName,
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
                              message.message,
                              softWrap: true,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
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