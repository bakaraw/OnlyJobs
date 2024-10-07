import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:only_job/models/education.dart';

class UserService {
  UserService({required this.uid});

  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference get _userRef => userCollection.doc(uid);

  String _defaultPfp =
      "https://firebasestorage.googleapis.com/v0/b/onlyjob-13c80.appspot.com/o/commons%2Fjames-pfp.jpg?alt=media&token=ce36246e-04bc-42cc-98ab-7c08ac8591b3";

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
        'pending': [],
        'website': null,
        'isUserNew': true,
        'skills': [],
        'profile_picture': _defaultPfp,
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
        isUserNew: snapshot.get('isUserNew'),
        profilePicture: snapshot.get('profile_picture'),
        skills: snapshot.get('skills') ?? [],
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
      isUserNew: snapshot.get('isUserNew'),
      profilePicture: snapshot.get('profile_picture'),
    );
  }

  Future<void> setUserNotNew() async {
    try {
      return await userCollection.doc(uid).update({'isUserNew': false});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileExt = file.path.split('.').last;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final uploadRef =
          storageRef.child("$uid/uploads/$timeStamp-profile-picture.$fileExt");

      await uploadRef.putFile(file);
      return uploadRef.getDownloadURL();
    } catch (e) {
      log("Error uploading image");
      log(e.toString());
    }
    return null;
  }

  Future<String?> uploadImageFromBytes(Uint8List bytes) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final uploadRef =
          storageRef.child("$uid/uploads/$timeStamp-profile-picture.jpg");

      log("Uploading file to: ${uploadRef.fullPath}");

      await uploadRef.putData(bytes);
      return uploadRef.getDownloadURL();
    } catch (e) {
      log("Error uploading image");
      log(e.toString());
    }
    return null;
  }

  Future<void> updateProfilePicture(String url) async {
    try {
      return await userCollection.doc(uid).update({'profile_picture': url});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Uint8List?> fetchImageBytes(String url) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  Future<void> addSkills(String skill) async {
    try {
      return await userCollection.doc(uid).update({
        'skills': FieldValue.arrayUnion([skill]),
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> removeSkill(String skill) async {
    try {
      return await userCollection.doc(uid).update({
        'skills': FieldValue.arrayRemove([skill]),
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Education>> getEducationList() async {
    try {
      final QuerySnapshot snapshot =
          await userCollection.doc(uid).collection('education').get();
      final List<Education> educationList =
          snapshot.docs.map((doc) => Education.fromDocument(doc)).toList();
      return educationList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // make a sub-collection for job openings
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
