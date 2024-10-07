import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/education.dart';

class EducationService {
  EducationService({required this.uid});
  final String uid;
  final CollectionReference educationCollection =
      FirebaseFirestore.instance.collection('User');
  DocumentReference get _userRef => educationCollection.doc(uid);

  Future addEducation(String school, String degree, String endDate) async {
    try {
      return await educationCollection.doc(uid).collection('education').add({
        'university': school,
        'degree': degree,
        'year': endDate,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Education _educationFromSnapshot(DocumentSnapshot snapshot) {
    return Education(
      university: snapshot.get('university'),
      degree: snapshot.get('degree'),
      year: snapshot.get('year'),
    );
  }

  Stream<List<Education>> get education {
    return educationCollection.doc(uid).collection('education').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => _educationFromSnapshot(doc)).toList());
  }
}
