import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/home/employer_homepage.dart';
import 'package:only_job/views/home/employer_profile.dart';
import 'package:only_job/views/home/job_details.dart';
import 'package:only_job/views/home/job_opening.dart';
import 'package:only_job/services/job_service.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/models/jobs.dart';

class EmployerPositions extends StatefulWidget {
  const EmployerPositions({super.key});

  @override
  State<EmployerPositions> createState() => _EmployerPositionsState();
}

class _EmployerPositionsState extends State<EmployerPositions> {
  AuthService _auth = AuthService();
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Job Positions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<JobData>>(
          stream: JobService(uid: _auth.getCurrentUserId()!).jobOpenings,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            if (snapshot.hasData) {
              return _buildJobPositions(snapshot.data!);
            }

            return const Loading();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobOpeningForm()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildJobPositions(List<JobData> jobPositions) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: jobPositions.length,
      itemBuilder: (context, index) {
        final job = jobPositions[index];
        final int notificationCount = 5;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailsPage(jobData: job),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Title: ' + job.jobTitle!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          job.jobDescription!,
                          style: TextStyle(fontSize: 16),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: notificationCount > 0
                    ? Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
