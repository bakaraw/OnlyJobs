import 'package:only_job/models/jobs.dart';
import 'package:only_job/models/user.dart';

class JobMatcher {
  //DocumentSnapshot? lastDocument;

  List<JobData> recommendJobsForUser(UserData user, List<JobData> jobs){
    List<JobData> recommendedJobs = [];
    for (var job in jobs){
       int matchingSkillsCount = user.skills!
          .where((skill) => job.skillsRequired!.contains(skill))
          .length;

       if (matchingSkillsCount > 0) {
        recommendedJobs.add(job);
      }
    }
    return recommendedJobs;
  }
}
