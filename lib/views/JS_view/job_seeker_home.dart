import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/models/education.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/services/job_service.dart';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/services/job_recommendation_controller.dart';
import 'package:only_job/services/job_matcher.dart';
import 'package:only_job/chatFeature/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  Function changePage;
  HomePage({super.key, required this.changePage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String uid;
  late AuthService _auth;
  late UserService _userService;
  late JobService _jobService;
  late List<JobData> _jobs;
  late final JobRecommendationController jobRecommendationController;
  late final JobMatcher jobMatcher;
  final PageController _pageController = PageController();

  bool _isJobLoading = false;
  bool _isJobLoadingMore = false;
  bool _hasMore = true;

  Education? education;
  List<dynamic>? skills = [];
  bool _isLoading = true;

  Map<String, UserData> _prefetchedUserData = {};

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
    _pageController.addListener(_onPageChanged);
    _loadInitialJobs();
    getSkills();
    getEducation();
  }

  void getEducation() async {
    final education = await _userService.getFirstUserEducation();
    setState(() {
      this.education = education;
      _isLoading = false;
    });
  }

  void getSkills() async {
    final skills = await _userService.getSkills();
    setState(() {
      this.skills = skills;
      _isLoading = false;
    });
  }

  void _onPageChanged() {
    if (_pageController.page == _jobs.length - 1 &&
        !_isJobLoadingMore &&
        _hasMore) {
      _loadMoreJobs();
    }
  }

  void _loadMoreJobs() async {
    if (_isJobLoadingMore || !_hasMore) return;

    setState(() {
      _isJobLoadingMore = true;
    });

    // Fetch more job recommendations
    List<JobData> moreJobs =
        await jobRecommendationController.fetchInitialJobsRecommendations(uid);

    // Prefetch user data for the additional jobs
    for (var job in moreJobs) {
      UserData userData = await _userService.getUserById(job.owner!);
      _prefetchedUserData[job.owner!] = userData;
    }

    setState(() {
      _jobs.addAll(moreJobs); // Append the new jobs to the list
      _isJobLoadingMore = false;
      _hasMore = jobRecommendationController.hasMore; // Update hasMore flag
    });
  }

  void _loadInitialJobs() async {
    setState(() {
      _isJobLoading = true;
    });

    List<JobData> jobs =
        await jobRecommendationController.fetchInitialJobsRecommendations(uid);

    for (var job in jobs) {
      UserData userData = await _userService.getUserById(job.owner!);
      _prefetchedUserData[job.owner!] = userData;
    }

    setState(() {
      _jobs = jobs;
      _isJobLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'Logo.png',
                        height: 60,
                      ),
                      StreamBuilder<UserData>(
                        stream: _userService.userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.5,
                                      alignment: Alignment.topRight,
                                      child: _buildProfileModal(
                                          context, snapshot.data!),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[300],
                                child: ClipOval(
                                    child: Image.network(
                                        snapshot.data!.profilePicture!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover)),
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
                if (skills!.isEmpty)
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        height: 60, // Fixed height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow[100],
                          border:
                              Border.all(color: Colors.amber[300]!, width: 1),
                        ),

                        padding: const EdgeInsets.symmetric(
                            horizontal: 16), // Optional padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Align text to the left and button to the right
                          children: [
                            Text(
                              'Set up profile to get started',
                              style: TextStyle(
                                  fontSize: 16), // Customize the text style
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.changePage(0);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: const Text(
                                'Set-up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )),
                Expanded(
                  child: _isJobLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _jobs.isNotEmpty
                          ? PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.vertical,
                              itemCount: _jobs.length + 1,
                              itemBuilder: (context, index) {
                                if (index < _jobs.length && _jobs.isNotEmpty) {
                                  JobData job = _jobs[index];
                                  UserData? jobOwner =
                                      _prefetchedUserData[job.owner!];
                                  if (jobOwner == null) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomBodyWidget(
                                        jobData: job, jobOwner: jobOwner),
                                  );
                                } else {
                                  return _isJobLoadingMore
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Center(
                                          child: Text(
                                              'No more jobs available yet'),
                                        );
                                }
                              })
                          : const Center(
                              child: Text(
                                  'No jobs available for you at the moment'),
                            ),
                ),
              ],
            ),
          );
  }

  Widget _buildProfileModal(BuildContext context, UserData userData) {
    final skillsString = userData.skills!.map((skill) => '- $skill').join('\n');
    return Container(
      decoration: const BoxDecoration(
        color: backgroundwhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: Image.network(
                      userData.profilePicture!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (education != null)
                        Text(
                          education!.degree!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      if (education == null)
                        const Text(
                          'No education details',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Skills:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (skillsString.isNotEmpty)
              Text(
                skillsString,
                style: TextStyle(fontSize: 16),
              ),
            if (skillsString.isEmpty)
              const Text(
                'No skills added',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomBodyWidget extends StatefulWidget {
  CustomBodyWidget({super.key, required this.jobData, required this.jobOwner});
  JobData jobData;
  UserData jobOwner;

  @override
  State<CustomBodyWidget> createState() => _CustomBodyWidgetState();
}

class _CustomBodyWidgetState extends State<CustomBodyWidget> {
  final AuthService authService = AuthService();
  late final UserService userService;

  String? jobUid;
  String? receiverUid;
  String? currentUserName;
  String? ownerName; // New variable to store the owner's name
  String? profilePicture; // New variable to store the owner's name

  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
    jobUid = widget.jobData.jobUid;
    receiverUid = widget.jobData.owner;
    getOwnerName(receiverUid!);
  }

  Future<void> getOwnerName(String ownerUid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(ownerUid).get();

    if (userDoc.exists) {
      String name = userDoc.get('name');
      String? fetchedProfilePicture = userDoc.get('profile_picture');

      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          ownerName = name;
          profilePicture = fetchedProfilePicture;
        });
      }
    }
  }

  void fetchCurrentUserName() async {
    String? fetchedCurrentUserName = await authService.getCurrentUserName();
    userService = UserService(uid: authService.getCurrentUserId()!);

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        currentUserName = fetchedCurrentUserName;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> applyForJob() async {
    String? jobOwnerUid = widget.jobData.owner; // Job owner's UID from job data
    String? jobUid = widget.jobData.jobUid; // Job UID from job data
    String? currentUserName =
        this.currentUserName; // Current user's name (fetched earlier)

    if (jobOwnerUid != null) {
      try {
        // Reference to the specific job opening under the job owner's JobOpenings subcollection
        DocumentReference jobDocRef = FirebaseFirestore.instance
            .collection('User')
            .doc(jobOwnerUid)
            .collection('JobOpenings')
            .doc(jobUid);

        // Add current user to the 'pending_applicants' subcollection under the job opening
        await jobDocRef
            .collection('pending_applicants')
            .doc(authService.getCurrentUserId()!)
            .set({
          'name': currentUserName,
          'applied_at': FieldValue.serverTimestamp(),
          'uid': authService.getCurrentUserId(),
        });

        await userService.recordJobInteraction(authService.getCurrentUserId()!,jobUid, "applied");

        // Notify the user that their application is pending
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your application is pending review.')),
        );
      } catch (e) {
        // Handle any errors during the application process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply: $e')),
        );
      }
    } else {
      // Handle case where current user or job owner UID is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to apply. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // Increased height to accommodate the job description section
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Image section
          if (widget.jobData.image != null)
            Container(
              height: 250, // Fixed height for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(widget.jobData.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          if (widget.jobData.image == null)
            Container(
              height: 250, // Fixed height for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage("sample_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 8), // Spacing

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobData.jobTitle!, // Replace with actual job title
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Vertical spacing
                  Text(
                    '${widget.jobOwner.name}', // Replace with actual company name
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Container(
                  child: Wrap(
                    spacing: 8.0, // Space between chips
                    runSpacing: 4.0, // Space between lines of chips
                    children: widget.jobData.skillsRequired!
                        .take(4)
                        .map<Widget>((skill) => Chip(label: Text(skill)))
                        .toList(),
                  ),
                ),
              ])),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 4.0), // Padding for location
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.jobData
                        .jobDescription!, // Replace with actual location
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    maxLines: 5,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          // Location section
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 4.0), // Padding for location
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(children: [
                      Row(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Salary Range',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$${widget.jobData.minSalaryRange!} - \$${widget.jobData.maxSalaryRange}', // Replace with actual date
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ]),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock_clock,
                                color: Colors.black87), // Calendar icon
                            SizedBox(width: 4), // Space between icon and text
                            Text(
                              widget
                                  .jobData.jobType!, // Replace with actual date
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(children: [
                      Row(children: [
                        Icon(Icons.location_on,
                            color: Colors.red), // Calendar icon
                        const SizedBox(width: 4), // Space between icon and text
                        Text(
                          widget.jobData.location!, // Replace with actual date
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      ]),
                    ]),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),
          // Apply Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print('Apply button clicked');
                applyForJob();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey), // Added border here
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 300, // Fixed width for each section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4), // Vertical spacing
          Text(
            content,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
