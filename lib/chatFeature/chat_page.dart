import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/chatFeature/display_message.dart';
import 'package:only_job/chatFeature/profile.dart';
import 'package:only_job/chatFeature/skills.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/constants/loading.dart';
import '../models/message.dart';
import '../services/auth.dart';
import '../views/JS_view/job_seeker_home.dart';
import '../views/JS_view/job_seeker_nav.dart';
import '../views/home/employer_homepage.dart';
import 'chat_list.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService authService = AuthService();

  String? currentUserName;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
  }

  void fetchCurrentUserName() async {
    currentUserName = await authService.getCurrentUserName();
    setState(() {});
  }


  Future<bool> checkIfJobSeeker() async {
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection('User')
        .doc(auth.currentUser?.uid)
        .get();
    return userDoc['isJobSeeker'] ?? true;
  }


  @override
  Widget build(BuildContext context) {
    String receiverName = widget.user['name'] ?? 'Unknown';
    String receiverUserId = widget.user['uid'] ?? ''; // Ensure this is the receiver's UID

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.user['name'] ?? 'Unknown',
              style: usernameStylewithSecondaryColor,
            ),
            backgroundColor: primarycolor,
            actions: [
              FutureBuilder<bool>(
                future: checkIfJobSeeker(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator while waiting for data
                  }

                  if (snapshot.hasError) {
                    return Icon(Icons.error, color: Colors.red); // Handle errors
                  }


                  bool isJobSeeker = snapshot.data ?? false;

                  return IconButton(
                    color: Colors.blueAccent,
                    onPressed: () async {
                      if (isJobSeeker) {
                        showSkillsBottomSheet(receiverUserId, context);
                      } else {
                        showProfileBottomSheet(receiverUserId, context);

                      }
                    },
                    icon: Icon(
                      isJobSeeker ? Icons.list : Icons.person,
                      color: secondarycolor,
                    ),
                  );
                },
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: secondarycolor),
            ),
          ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Display messages for the chat
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: DisplayMessage(
                      user: receiverName,
                      receiverUserId: receiverUserId,
                      senderUserId: auth.currentUser?.uid ?? '',
                      // Pass the receiver user ID
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Message",
                              contentPadding: EdgeInsets.only(left: 15, bottom: 8, top: 8),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primarycolor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              messageController.text = value!;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (messageController.text.isNotEmpty) {
                              // Create the message object
                              Message newMessage = Message(
                                message: messageController.text.trim(),
                                time: DateTime.now(),
                                senderName: currentUserName ?? 'Unknown',
                                senderId: auth.currentUser?.uid ?? '',
                                receiver: receiverName,
                              );

                              String currentUserId = auth.currentUser?.uid ?? '';
                              String receiverUserId = widget.user['uid'] ?? '';

                              // Add the message to both the receiver's and sender's message subcollections
                              DocumentReference receiverDocRef = firebaseFirestore
                                  .collection('User')
                                  .doc(receiverUserId)
                                  .collection('messages')
                                  .doc(currentUserId);

                              DocumentReference senderDocRef = firebaseFirestore
                                  .collection('User')
                                  .doc(currentUserId)
                                  .collection('messages')
                                  .doc(receiverUserId);

                              try {
                                // Send the message to both users
                                await receiverDocRef.collection('chatMessages').add(newMessage.toMap());
                                await senderDocRef.collection('chatMessages').add(newMessage.toMap());

                                // Update the sender's contacts
                                await firebaseFirestore.collection('User').doc(currentUserId).set({
                                  'contacts': FieldValue.arrayUnion([receiverUserId]), // Add to sender's contacts
                                }, SetOptions(merge: true));

                                // Check the receiver's contact list
                                DocumentSnapshot receiverDoc = await firebaseFirestore.collection('User').doc(receiverUserId).get();
                                List<dynamic> receiverContacts = receiverDoc['contacts'] ?? [];
                                List<dynamic> pendingList = receiverDoc['pending'] ?? [];

                                // Only add the sender to the receiver's pending list if not in the contacts
                                if (!receiverContacts.contains(currentUserId)) {
                                  if (!pendingList.contains(currentUserId)) {
                                    await firebaseFirestore.collection('User').doc(receiverUserId).set({
                                      'pending': FieldValue.arrayUnion([currentUserId]), // Add sender to receiver's pending
                                    }, SetOptions(merge: true));
                                  }
                                }

                                // Clear the message input
                                messageController.clear();
                              } catch (e) {
                                print('Error sending message: $e');
                              }
                            }
                          },
                          icon: Icon(Icons.send, size: 30, color: primarycolor),
                        ),
                        SizedBox(height: 5,),

                      ],
                    ),
                  ),
                ],
              ),
        ),
        bottomNavigationBar: BottomAppBar(
        height: 60,
        color: primarycolor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // This spaces the icons
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<bool>(
                      future: checkIfJobSeeker(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.data == true) {
                            return NavJS(); // Job Seeker
                          } else {
                            return ClientHomePage(); // Client
                          }
                        } else {
                          return Center(child: Loading());
                        }
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.people, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}