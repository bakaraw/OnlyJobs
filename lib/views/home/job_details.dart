import 'package:flutter/material.dart';
import 'package:only_job/models/jobs.dart';
import 'package:only_job/views/constants/constants.dart';

class JobDetailsPage extends StatefulWidget {
  final JobData jobData;

  JobDetailsPage({required this.jobData});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Job Title: ${widget.jobData.jobTitle}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Delete the ${widget.jobData.jobTitle} Job Opening?'),
                                  content: Text(
                                      'This will also delete all job seeker applications'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.red),
                                      ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Salary Range: \$${widget.jobData.minSalaryRange!} - \$${widget.jobData.maxSalaryRange!}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Location: ${widget.jobData.location}',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Skills Required:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.jobData.skillsRequired!.map((skill) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text('- $skill', style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  'Job Description: ${widget.jobData.jobDescription}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Close the ${widget.jobData.jobTitle} Job Opening?'),
                              content: Text(
                                  'Job seekers will no longer find this Job Opening'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes'),
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
                      child: Text('Close this Job Opening'),
                    ),
                  ],
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
