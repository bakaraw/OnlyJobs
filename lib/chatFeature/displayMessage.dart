import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/constants/loading.dart';

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

  Future<String?> receiverProfilePicture(String receiverUserId) async {
    try {
      // Fetching the receiver's document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(receiverUserId) // Use receiverUserId directly
          .get();

      // Check if the user exists and retrieve the profile picture
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data();
        return userData?['profile_picture'] ?? null; // Return profile picture URL or null
      } else {
        return null; // Return null if user does not exist
      }
    } catch (e) {
      print('Error getting profile picture: $e');
      return null; // Handle errors by returning null
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred", style: errortxtstyle,));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        // Check if there are no messages
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("No messages found", style: usernameStyle,));
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
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300, // Limit the width of each ListTile
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: primarycolor),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          // Set the background color based on the sender ID
                          tileColor: message.senderName == widget.receiverUserId
                              ? primarycolor : secondarycolor,

                          // Add profile picture in the leading section
                          leading: FutureBuilder<String?>(
                            future: receiverProfilePicture(message.senderName), // Use receiverUserId from the message
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Loading indicator while fetching the image
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                ); // Display the profile picture
                              } else {
                                return CircleAvatar(
                                  child: Icon(Icons.person),
                                ); // Default avatar when there's no profile picture
                              }
                            },
                          ),

                          title: Text(
                            message.senderName,
                            style: usernameStyle,
                            textAlign: TextAlign.left, // Centering the title text
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
                      SizedBox(height: 8), // Add some space between ListTile and time
                      Text(
                        '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
