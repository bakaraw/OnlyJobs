import 'package:only_job/services/user_service.dart';
import 'package:only_job/services/job_service.dart';
import 'package:only_job/services/job_matcher.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/models/jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobRecommendationController {
  
  final UserService userService;
  final JobService jobService;
  final JobMatcher jobMatcher;

  JobRecommendationController({required this.userService, required this.jobMatcher, required this.jobService});

  Future<List<JobData>> fetchInitialJobsRecommendations(String userId) async {
    UserData user = await userService.getUserData();
    if (user != null) {
      List<JobData> jobs = await jobService.fetchInitialJob(userService, userId);
      return jobMatcher.recommendJobsForUser(user, jobs);
    }
    return [];
  }

  Future<List<JobData>> fetchMoreJobsRecommendations(String userId) async {
    UserData user = await userService.getUserData();
    if (user != null) {
      List<JobData> jobs = await jobService.fetchMoreJobs(userService, userId);
      return jobMatcher.recommendJobsForUser(user, jobs);
    }
    return [];
  }

  bool get hasMore => jobService.hasMoreData;
  DocumentSnapshot? get lastDocument => jobService.lastDoc;
}
