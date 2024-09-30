import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/services/auth.dart';
import '../views/constants/loading.dart';

class UserSearchDelegate extends SearchDelegate {



  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }




  Future<void> _addContact(String contactId) async {
    String currentUserId = auth.currentUser!.uid;
    DocumentReference userDocRef = firestore.collection('User').doc(currentUserId);

    await userDocRef.update({
      'contacts': FieldValue.arrayUnion([contactId]),
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('User')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Loading());
        }
        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final userData = userDoc.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(userData['name']),
              subtitle: Text(userData['email']),
              onTap: () async {

                String userName = userData['name'] ?? 'No Name'; // Name

                final userExistNotPush = await firestore
                    .collection('messenges')
                    .where('name', isEqualTo: userData['name'])
                    .get();

                await _addContact(userDoc.id);
                close(context, userData);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}