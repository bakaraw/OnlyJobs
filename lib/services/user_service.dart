import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');

  Future<void> addUser(String uid, String name, String email, String phone, String address) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    });
  }

  
}
