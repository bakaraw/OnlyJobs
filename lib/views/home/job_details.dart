import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/views/constants/constants.dart';

import '../../services/job_service.dart';

class JobDetailsPage extends StatefulWidget {
  final JobData jobData;


  JobDetailsPage({required this.jobData});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool isEditing = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController minSalaryController = TextEditingController();
  TextEditingController maxSalaryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  String? jobUid; // Declare jobUid here

  @override
  void initState() {
    super.initState();
    titleController.text = widget.jobData.jobTitle!;
    minSalaryController.text = widget.jobData.minSalaryRange.toString();
    maxSalaryController.text = widget.jobData.maxSalaryRange.toString();
    locationController.text = widget.jobData.location!;
    skillsController.text = widget.jobData.skillsRequired!.join(', ');
    jobDescriptionController.text = widget.jobData.jobDescription!;

    jobUid = widget.jobData.jobUid;
    if (jobUid != null) {
      JobService jobService = JobService(uid: jobUid!); // Use jobUid here
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    locationController.dispose();
    skillsController.dispose();
    jobDescriptionController.dispose();
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
        'skillsRequired': skillsController.text
            .split(',')
            .map((s) => s.trim())
            .toList(),
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
  List<String> teamMembers = [
    "John Doe",
    "Jane Smith",
    'Bilat',
    'Meg',
    'Peter',
    'BumbleBee',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        titleTextStyle: headingStyle,
        backgroundColor: primarycolor,
      ),
      body: Column(
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
                        'Salary Range: \$${minSalaryController
                            .text} - \$${maxSalaryController.text}',
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
                          ? TextField(
                        controller: skillsController,
                        decoration: InputDecoration(
                          labelText: 'Skills (comma-separated)',
                          border: OutlineInputBorder(),
                        ),
                      )
                          : Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: skillsController.text
                            .split(',')
                            .map((skill) =>
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5.0),
                              child: Text('- $skill',
                                  style: TextStyle(
                                      fontSize: 16)),
                            ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),

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
                        'Job Description: ${jobDescriptionController
                            .text}',
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
                          IconButton(
                            icon: Icon(isEditing
                                ? Icons.check
                                : Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (isEditing) {
                                  updateJobInFirebase(); // Save updates
                                }
                                isEditing = !isEditing;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable list of applicants (team members)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: teamMembers
                    .map(
                      (member) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Skill'),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: accent1),
                                onPressed: () {
                                  setState(() {
                                    teamMembers.remove(member);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
