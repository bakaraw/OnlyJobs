import 'package:flutter/material.dart';
import 'package:only_job/models/jobs.dart';

class JobDetailsPage extends StatelessWidget {
  final JobData jobData;

  JobDetailsPage({required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Title: ${jobData.jobTitle}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Salary Range: \$${jobData.minSalaryRange!} - \$${jobData.maxSalaryRange!}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text('Location: ${jobData.location}', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text('Skills Required:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: jobData.skillsRequired.map((skill) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text('- $skill', style: TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                  ),
                  Text('Job Description: ${jobData.jobDescription}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                'Diri sa ubos gusto nako kay tiles sa mga job seekers nga nagsubmit ug resume'),
          ],
        ),
      ),
    );
  }
}
