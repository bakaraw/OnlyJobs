import 'package:cloud_firestore/cloud_firestore.dart';

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
    });
  }

  Future addEmployer(
      String name, String email, String phone, String address) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'isJobSeeker': true,
    });
  }
}
