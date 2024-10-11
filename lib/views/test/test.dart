import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/services/job_service.dart';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/services/job_recommendation_controller.dart';
import 'package:only_job/services/job_matcher.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late AuthService _auth;
  late UserService _userService;
  late JobService _jobService;
  late List<JobData> _jobs;
  late final JobRecommendationController jobRecommendationController;
  late final JobMatcher jobMatcher;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  late String uid;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    String uid = _auth.getCurrentUserId()!;
    this.uid = uid;
    _userService = UserService(uid: uid);
    _jobService = JobService(uid: uid);
    jobRecommendationController = JobRecommendationController(
        userService: _userService,
        jobService: _jobService,
        jobMatcher: JobMatcher());
    _scrollController.addListener(_onScroll);
    _loadInitialJobs();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore) {
      _loadMoreJobs();
    }
  }

  void _loadMoreJobs() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    List<JobData> moreJobs =
        await jobRecommendationController.fetchInitialJobsRecommendations(uid);

    setState(() {
      _jobs.addAll(moreJobs);
      _isLoadingMore = false;
      _hasMore = jobRecommendationController.hasMore;
    });
  }

  void _loadInitialJobs() async {
    setState(() {
      _isLoading = true;
    });

    List<JobData> jobs =
        await jobRecommendationController.fetchInitialJobsRecommendations(uid);

    setState(() {
      _jobs = jobs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Recommendations')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _jobs.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _jobs.length && _isLoadingMore) {
                  return Center(child: CircularProgressIndicator());
                }
                JobData job = _jobs[index];
                return ListTile(
                  title: Text(job.jobTitle!),
                  subtitle:
                      Text("Required Skills: ${job.skillsRequired!.join(', ')}"),
                );
              },
            ),
    );
  }

  Widget buildContents(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const Text('Hello World'),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              _auth.signOut();
            },
            child: const Text('Sign Out'),
          ),
          if (_jobs != null)
            for (var jobs in _jobs)
              ListTile(
                title: Text('Item ${jobs.jobTitle!}'),
              ),
        ],
      ),
    );
  }
}
