import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:only_job/models/education.dart';
import 'package:only_job/models/experience.dart';
import 'package:only_job/models/certification.dart';

class UserService {
  UserService({required this.uid});

  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference get _userRef => userCollection.doc(uid);

  final String defaultPfp =
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
        'profile_picture': defaultPfp,
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

  // upload a file or an image
  Future<String?> uploadFile(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileExt = file.path.split('.').last;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final uploadRef = storageRef.child("$uid/uploads/$timeStamp.$fileExt");

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

  // fetch the user's skills
  Future<List<dynamic>> getSkills() async {
    try {
      final DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      return snapshot.get('skills');
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

  Future<UserData> getUserData() async {
    try {
      final DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      return _userDataFromSnapshot(snapshot);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // make a sub-collection for job openings
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // methods for adding education
  Future addEducation(String school, String degree, String endDate) async {
    try {
      return await userCollection.doc(uid).collection('education').add({
        'university': school,
        'degree': degree,
        'year': endDate,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateEducation(
      String school, String degree, String endDate, String docId) async {
    try {
      return await userCollection
          .doc(uid)
          .collection('education')
          .doc(docId)
          .update({
        'university': school,
        'degree': degree,
        'year': endDate,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteEducation(String docId) async {
    try {
      return await userCollection
          .doc(uid)
          .collection('education')
          .doc(docId)
          .delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Education _educationFromSnapshot(DocumentSnapshot snapshot) {
    return Education(
      uid: snapshot.id,
      university: snapshot.get('university'),
      degree: snapshot.get('degree'),
      year: snapshot.get('year'),
    );
  }

  Future<Education?> getFirstUserEducation() async {
    try {
      // Reference to the education subcollection under the specific user document
      CollectionReference educationRef = _userRef
          .collection('education');

      // Retrieve the education documents (limit to 1 for efficiency)
      QuerySnapshot educationSnapshot = await educationRef.limit(1).get();

      // Check if there are any documents
      if (educationSnapshot.docs.isNotEmpty) {
        // Get the first document
        var firstDoc = educationSnapshot.docs.first;
        return Education.fromDocument(firstDoc);
      } else {
        print("No education records found.");
        return null;
      }
    } catch (e) {
      print("Error fetching education subcollection: $e");
      return null;
    }
  }

  Stream<List<Education>> get education {
    return userCollection.doc(uid).collection('education').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => _educationFromSnapshot(doc)).toList());
  }

  // methods for adding experience
  Future<void> addExperience(String company, String title, String description,
      String location, DateTime startDate, DateTime endDate) async {
    try {
      // Ensure the date fields are stored correctly
      await userCollection.doc(uid).collection('experience').add({
        'company': company,
        'title': title,
        'description': description,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
      });
    } catch (e) {
      // Log the error with additional context
      log("Error adding experience for user $uid: $e");
      rethrow;
    }
  }

  Future<void> updateExperience(
      String company,
      String title,
      String description,
      String location,
      DateTime startDate,
      DateTime endDate,
      String docId) async {
    try {
      // Ensure the date fields are stored correctly
      await userCollection.doc(uid).collection('experience').doc(docId).update({
        'company': company,
        'title': title,
        'description': description,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
      });
    } catch (e) {
      // Log the error with additional context
      log("Error updating experience for user $uid: $e");
      rethrow;
    }
  }

  Future<void> deleteExperience(String docId) async {
    try {
      return await userCollection
          .doc(uid)
          .collection('experience')
          .doc(docId)
          .delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Experience _experienceFromSnapshot(DocumentSnapshot snapshot) {
    return Experience(
      uid: snapshot.id,
      company: snapshot.get('company'),
      title: snapshot.get('title'),
      description: snapshot.get('description'),
      location: snapshot.get('location'),
      startDate: snapshot.get('startDate').toDate(),
      endDate: snapshot.get('endDate').toDate(),
    );
  }

  Stream<List<Experience>> get experience {
    return userCollection.doc(uid).collection('experience').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => _experienceFromSnapshot(doc)).toList());
  }

  Future<void> addCertification(
      String certificationName, String date, String? attachedFile) async {
    try {
      await userCollection.doc(uid).collection('certifications').add({
        'certificationName': certificationName,
        'date': date,
        'attachedFile': attachedFile,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Certification _certificationFromSnapshot(DocumentSnapshot snapshot) {
    return Certification(
      uid: snapshot.id,
      certificationName: snapshot.get('certificationName'),
      date: snapshot.get('date'),
      attachedFile: snapshot.get('attachedFile'),
    );
  }

  // delete certification and the attached file
  Future<void> deleteCertification(String docId, String? attachedFile) async {
    try {
      if (attachedFile != null) {
        final storageRef = FirebaseStorage.instance.refFromURL(attachedFile);
        await storageRef.delete();
      }
      return await userCollection
          .doc(uid)
          .collection('certifications')
          .doc(docId)
          .delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<Certification>> get certifications {
    return userCollection.doc(uid).collection('certifications').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => _certificationFromSnapshot(doc))
            .toList());
  }
}
