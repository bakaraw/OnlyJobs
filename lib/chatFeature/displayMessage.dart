import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatefulWidget {
  final String user;

  const DisplayMessage({super.key, required this.user});

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  final Stream<QuerySnapshot> messageStream =
  FirebaseFirestore.instance.collection('Messages').orderBy('time').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("An error occurred");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

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
                        qds['name'],
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
                              qds['message'], // Display actual message content
                              softWrap: true,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('${dateTime.hour}:${dateTime.minute}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}