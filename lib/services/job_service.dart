import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/jobs.dart';

class JobService {
  JobService({required this.uid});
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  DocumentReference get _userRef => userCollection.doc(uid);

  Future<void> addJobOpening(
      String title,
      String description,
      String location,
      int minSalary,
      int maxSalary,
      String jobType,
      String jobCategory,
      List<String> skillsRequired) async {
    try {
      await _userRef.collection('JobOpenings').add({
        'jobTitle': title,
        'description': description,
        'location': location,
        'minimumSalary': minSalary,
        'maximumSalary': maxSalary,
        'jobType': jobType,
        'skillsRequired': skillsRequired,
        'isOpened': true,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  JobData _jobDataFromSnapshot(DocumentSnapshot snapshot){
    return JobData(
      uid: uid,
      jobTitle: snapshot.get('jobTitle'),
      jobDescription: snapshot.get('description'),
      location: snapshot.get('location'),
      minSalaryRange: snapshot.get('minimumSalary').toString(),
      maxSalaryRange: snapshot.get('maximumSalary').toString(),
      jobType: snapshot.get('jobType'),
      skillsRequired: List<String>.from(snapshot.get('skillsRequired')),
      isOpened: snapshot.get('isOpened'),
    );
  }

  Stream<List<JobData>> get jobOpenings {
    return _userRef.collection('JobOpenings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => _jobDataFromSnapshot(doc)).toList());
  }
}
