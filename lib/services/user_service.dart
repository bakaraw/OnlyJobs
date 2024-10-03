import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/user.dart';

class UserService {
  UserService({required this.uid});

  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference get _userRef => userCollection.doc(uid);

  Future addUser(String name, String? gender, DateTime? birthDate, String email,
      String phone, String address, bool isJobSeeker) async {
    try {
      return await userCollection.doc(uid).set({
        'name': name,
        'birth_date': birthDate,
        'email': email,
        'gender': gender,
        'phone': phone,
        'address': address,
        'isJobSeeker': isJobSeeker,
        'contacts': [],
        'website': null,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // update user data
  Future updateUserData(
      String name, String email, String phone, String address) async {
    try {
      return await userCollection.doc(uid).update(
          {'name': name, 'email': email, 'phone': phone, 'address': address});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateWebsite(String website) async {
    try {
      return await userCollection.doc(uid).update({
        'website': website,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    log(snapshot.get('name'));
    if (snapshot.get('isJobSeeker') == true) {
      return UserData(
        uid: uid,
        name: snapshot.get('name'),
        email: snapshot.get('email'),
        phone: snapshot.get('phone'),
        address: snapshot.get('address'),
        isJobSeeker: snapshot.get('isJobSeeker'),
        birthDate: snapshot.get('birth_date').toDate(),
        gender: snapshot.get('gender'),
        website: snapshot.get('website') ?? '',
      );
    }

    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      phone: snapshot.get('phone'),
      address: snapshot.get('address'),
      isJobSeeker: snapshot.get('isJobSeeker'),
      website: snapshot.get('website') ?? '',
      birthDate: null,
      gender: null,
    );
  }

  // make a sub-collection for job openings
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
