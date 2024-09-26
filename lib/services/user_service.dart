import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  final String uid;

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  UserService({required this.uid});

  Future addUser(String name, String? gender,
      DateTime? birthDate, String email, String phone, String address) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'gender': gender,
      'birth_date': birthDate,
      'email': email,
      'phone': phone,
      'address': address,
    });
  }
}
