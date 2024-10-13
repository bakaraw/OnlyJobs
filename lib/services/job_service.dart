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

  DocumentSnapshot? lastDocument;
  bool hasMore = true;
  int documentLimit = 20;

  DocumentSnapshot? get lastDoc => lastDocument;
  bool get hasMoreData => hasMore;

  Future<void> addJobOpening(
      String title,
      String description,
      String location,
      int minSalary,
      int maxSalary,
      String jobType,
      String requirements,
      List<String> skillsRequired,
      String imageUrl) async {
    try {
      await _userRef.collection('JobOpenings').add({
        'jobTitle': title,
        'description': description,
        'location': location,
        'minimumSalary': minSalary,
        'maximumSalary': maxSalary,
        'jobType': jobType,
        'skillsRequired': skillsRequired,
        'requirements': requirements,
        'owner': uid,
        'isOpened': true,
        'image': imageUrl,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // fetch all the job openings of users if the user is not a job_seeker
  Future<List<JobData>> fetchInitialJob() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collectionGroup('JobOpenings')
          //.where('isOpened', isEqualTo: true)
          .limit(documentLimit)
          .get();

      if (snapshot.docs.isEmpty) {
        hasMore = false;
      }

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }

      return snapshot.docs.map((doc) => _jobDataFromSnapshot(doc)).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<JobData>> fetchMoreJobs() async {
    if (!hasMore) return [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collectionGroup('JobOpenings')
        .startAfterDocument(lastDocument!)
        .limit(documentLimit)
        .get();

    if (snapshot.docs.isEmpty) {
      hasMore = false;
      return [];
    }

    lastDocument = snapshot.docs.last;

    return snapshot.docs.map((doc) => _jobDataFromSnapshot(doc)).toList();
  }

  JobData _jobDataFromSnapshot(DocumentSnapshot snapshot) {
    return JobData(
      uid: uid,
      owner: snapshot.get('owner'),
      jobTitle: snapshot.get('jobTitle'),
      jobDescription: snapshot.get('description'),
      location: snapshot.get('location'),
      minSalaryRange: snapshot.get('minimumSalary').toString(),
      maxSalaryRange: snapshot.get('maximumSalary').toString(),
      jobType: snapshot.get('jobType'),
      skillsRequired: List<String>.from(snapshot.get('skillsRequired')),
      otherRequirements: snapshot.get('requirements'),
      isOpened: snapshot.get('isOpened'),
      jobUid: snapshot.id,
      image: snapshot.get('image') ?? '',
    );
  }

  Stream<List<JobData>> get jobOpenings {
    return _userRef.collection('JobOpenings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => _jobDataFromSnapshot(doc)).toList());
  }

  // upload image for this job opening
  Future<void> uploadImage(String jobUid, String imageUrl) async {
    try {
      await _userRef.collection('JobOpenings').doc(jobUid).update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
