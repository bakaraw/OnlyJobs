import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserSearchDelegate extends SearchDelegate {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users') // Adjust this to your users collection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user['username']),
              onTap: () {
                // Handle user selection
                close(context, user);
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
