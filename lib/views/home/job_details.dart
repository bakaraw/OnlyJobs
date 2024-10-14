import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/views/home/job_seeker_profileview.dart';

import '../../chatFeature/chat_page.dart';
import '../../services/job_service.dart';
import '../../services/retrieve_skills.dart';
import 'common/search_skills.dart';
import 'employer_positions.dart';
import '../../services/auth.dart';
import '../../models/applicant.dart';

class JobDetailsPage extends StatefulWidget {
  final JobData jobData;

  JobDetailsPage({required this.jobData});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage>
    with SingleTickerProviderStateMixin {
  bool isEditing = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController minSalaryController = TextEditingController();
  TextEditingController maxSalaryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  String? jobUid;

  late List<String> skills = [];
  List<String> selectedSkills = [];
  String _skillsError = '';

  late Map<String, dynamic>? applicantData = {};
  late AuthService _auth;
  late JobService jobService;
  bool _loading = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    titleController.text = widget.jobData.jobTitle!;
    minSalaryController.text = widget.jobData.minSalaryRange.toString();
    maxSalaryController.text = widget.jobData.maxSalaryRange.toString();
    locationController.text = widget.jobData.location!;
    jobDescriptionController.text = widget.jobData.jobDescription!;
    jobUid = widget.jobData.jobUid;
    print('JobUid: $jobUid');
    selectedSkills = List<String>.from(widget.jobData.skillsRequired!);
    jobService = JobService(uid: jobUid!);
    _tabController = TabController(length: 2, vsync: this);
    _getApplicants();
    // Fetch skills only once during initialization
    _fetchSkills();
  }

  void _getApplicants() async {
    applicantData = await JobService(uid: _auth.getCurrentUserId()!)
        .getPendingApplicants(widget.jobData.jobUid);
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    locationController.dispose();
    jobDescriptionController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> updateJobInFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.jobData.owner)
          .collection('JobOpenings')
          .doc(jobUid)
          .update({
        'jobTitle': titleController.text,
        'minSalaryRange': double.tryParse(minSalaryController.text),
        'maxSalaryRange': double.tryParse(maxSalaryController.text),
        'location': locationController.text,
        'skillsRequired': selectedSkills, // Use the updated selectedSkills
        'description': jobDescriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job details updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update job: $e')),
      );
    }
  }

  Future<void> removeJobFromFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.jobData.owner)
          .collection('JobOpenings')
          .doc(jobUid)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete job: $e')),
      );
    }
  }

  Future<void> _fetchSkills() async {
    try {
      List<String> fetchedSkills =
          await RetrieveSkills().retrieveSkillsFromFirestore();
      setState(() {
        skills = fetchedSkills;
      });
    } catch (e) {
      print("Error fetching skills: $e");
      // Optionally, show a Snackbar or a dialog to indicate an error
    }
  }

  Future<void> _navigateAndSelectSkill(BuildContext context) async {
    final selectedSkill = await showSearch<String>(
      context: context,
      delegate: SearchSkills(skills: skills, addSkills: addSkills),
    );

    // Remove this since the addSkills method already updates selectedSkills
    // if (selectedSkill != null) {
    //   setState(() {
    //     _skillsRequiredController.text = selectedSkill;
    //   });
    // }
  }

  void addSkills(String skill) {
    setState(() {
      if (!selectedSkills.contains(skill)) {
        // Prevent duplicates
        selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Job Details'),
              titleTextStyle: headingStyle_white,
              backgroundColor: primarycolor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Fixed Job Info Container
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job Title
                              isEditing
                                  ? TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        labelText: 'Job Title',
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  : Text(
                                      'Job Title: ${titleController.text}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              const SizedBox(height: 10),

                              // Salary Range
                              isEditing
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: minSalaryController,
                                            decoration: InputDecoration(
                                              labelText: 'Min Salary',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            controller: maxSalaryController,
                                            decoration: InputDecoration(
                                              labelText: 'Max Salary',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Salary Range: \$${minSalaryController.text} - \$${maxSalaryController.text}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                              const SizedBox(height: 10),

                              // Location
                              isEditing
                                  ? TextField(
                                      controller: locationController,
                                      decoration: InputDecoration(
                                        labelText: 'Location',
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  : Text(
                                      'Location: ${locationController.text}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                              const SizedBox(height: 10),

                              // Skills Required
                              const Text(
                                'Skills Required:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              isEditing
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _navigateAndSelectSkill(context);
                                          },
                                          child: const Text("Add Skill"),
                                        ),
                                        const SizedBox(height: 10),

                                        // Display selected skills as chips
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: selectedSkills
                                              .map((skill) => Chip(
                                                    label: Text(skill),
                                                    onDeleted: () {
                                                      setState(() {
                                                        selectedSkills
                                                            .remove(skill);
                                                      });
                                                    },
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: selectedSkills
                                          .map((skill) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Text(skill,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ))
                                          .toList(),
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                              // Job Description
                              isEditing
                                  ? TextField(
                                      controller: jobDescriptionController,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        labelText: 'Job Description',
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  : Text(
                                      'Job Description: ${jobDescriptionController.text}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              const SizedBox(height: 20),

                              // Edit button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Edit/Save Button
                                  IconButton(
                                    icon: Icon(
                                        isEditing ? Icons.check : Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        if (isEditing) {
                                          updateJobInFirebase(); // Save updates
                                        }
                                        isEditing = !isEditing;
                                      });
                                    },
                                  ),

                                  // Conditionally show delete and close buttons only when not editing
                                  if (!isEditing) ...[
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Delete the ${widget.jobData.jobTitle} Job Opening?'),
                                              content: Text(
                                                  'This will also delete all job seeker applications.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await removeJobFromFirebase(); // Wait for job deletion from Firebase
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Yes',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Applicants'),
                      Tab(text: 'For Interview'),
                    ],
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        StreamBuilder<Map<String, dynamic>>(
                          stream: jobService.getPendingApplicantsStream(
                              jobUid!), // Replace with your method to fetch applicants
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No applicants found.'));
                            }

                            List<Applicant> applicantsList = [];
                            if (applicantData != null) {
                              applicantsList = snapshot.data!.values
                                  .map<Applicant>((applicant) =>
                                      Applicant.fromMap(applicant))
                                  .toList();
                            }

                            // Use the fetched list of applicants

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: applicantsList
                                    .map(
                                      (applicant) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                  jobUid: widget.jobData.jobUid,
                                                  uid: applicant.uid,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      applicant.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.close,
                                                      color: accent1),
                                                  onPressed: () {
                                                    jobService.deleteApplicant(
                                                        jobUid!, applicant.uid);
                                                    // Handle the close button action
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<Map<String, dynamic>>(
                          stream: jobService.getAcceptedApplicantsStream(
                              jobUid!), // Replace with your method to fetch applicants
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No applicants found.'));
                            }

                            List<Applicant> applicantsList = [];
                            if (applicantData != null) {
                              applicantsList = snapshot.data!.values
                                  .map<Applicant>((applicant) =>
                                      Applicant.fromMap(applicant))
                                  .toList();
                            }

                            // Use the fetched list of applicants

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: applicantsList
                                    .map(
                                      (applicant) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          padding: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    applicant.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text('Skill'),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.message_rounded,
                                                    color: primarycolor),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                        user: {
                                                          'name':
                                                              applicant.name,
                                                          // Pass the fetched owner's name
                                                          'uid': applicant.uid,
                                                          // Pass the receiver's UID
                                                        },
                                                      ),
                                                    ),
                                                  );

                                                  // Handle the close button action
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
