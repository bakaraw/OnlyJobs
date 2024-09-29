import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/user.dart';

class UserService {
  final String uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserService({required this.uid});

  Future addUser(String name, String gender, DateTime birthDate, String email,
      String phone, String address) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'birth_date': birthDate,
      'email': email,
      'phone': phone,
      'address': address,
      'isJobSeeker': true,
      'contacts': [],
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      phone: snapshot.get('phone'),
      address: snapshot.get('address'),
      isJobSeeker: snapshot.get('isJobSeeker'),
    );
  }

  Future addEmployer(
      String name, String email, String phone, String address) async {
    return await userCollection
        .doc(uid)
        .set({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'isJobSeeker': false,
          'contacts': [],
        });
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
