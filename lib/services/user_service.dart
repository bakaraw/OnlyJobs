import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class UserService {

  final String uid;

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserService({required this.uid});

  Future addUser(String name, String gender,
      DateTime birthDate, String email, String phone, String address) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'birth_date': birthDate,
      'email': email,
      'phone': phone,
      'address': address,
      'isJobSeeker': true,
    });
  }

}
