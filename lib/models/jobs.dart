
class Jobs {
  String? uid;

  Jobs({
    required this.uid,
  });
}

class JobData {
  final String jobUid;
  String? uid;
  String? jobTitle;
  String? jobDescription;
  String? location;
  String? minSalaryRange;
  String? maxSalaryRange;
  String? jobType;
  List<dynamic>? skillsRequired;
  bool? isOpened;
  String? otherRequirements;
  String? owner;

  JobData({
    required this.jobUid, // Initialize jobUid here
    required this.uid,
    required this.jobTitle,
    required this.jobDescription,
    required this.location,
    required this.minSalaryRange,
    required this.maxSalaryRange,
    required this.jobType,
    required this.skillsRequired,
    required this.isOpened,
    required this.otherRequirements,
    required this.owner,
  });
}
