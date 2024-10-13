import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/services/user_service.dart';

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

  Future<List<JobData>> fetchInitialJob(
      UserService userService, String uid) async {
    try {
      // Fetch the list of job IDs the user has interacted with
      List<String> interactedJobIds =
          await userService.fetchInteractedJobIds(uid);

      // Fetch job openings across all users with an optional filter
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collectionGroup('JobOpenings')
          //.where('isOpened', isEqualTo: true)  // Uncomment if needed
          .limit(documentLimit) // Limit the number of documents fetched
          .get();

      // Check if there are more documents to fetch
      if (snapshot.docs.isEmpty) {
        hasMore = false; // No more documents available
      } else {
        lastDocument =
            snapshot.docs.last; // Store the last document for pagination
      }

      // Filter out interacted jobs and convert to JobData instances
      return snapshot.docs
          .where((doc) =>
              !interactedJobIds.contains(doc.id)) // Exclude interacted jobs
          .map((doc) =>
              _jobDataFromSnapshot(doc)) // Ensure this function works correctly
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow; // Propagate the error for handling upstream
    }
  }

  Future<List<JobData>> fetchMoreJobs(
      UserService userService, String uid) async {
    if (!hasMore) return [];
    List<String> interactedJobIds =
        await userService.fetchInteractedJobIds(uid);

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

    return snapshot.docs
        .where((doc) =>
            !interactedJobIds.contains(doc.id)) // Exclude interacted jobs
        .map((doc) => _jobDataFromSnapshot(doc))
        .toList();
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

  Future<String?> getOwnerName(String ownerUid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(ownerUid)
          .get();

      if (userDoc.exists) {
        return userDoc.get('name');
      }
      return null; // Return null if user document does not exist
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}
