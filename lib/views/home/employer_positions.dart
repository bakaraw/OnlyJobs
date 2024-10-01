import 'package:flutter/material.dart';
import 'package:only_job/views/home/employer_homepage.dart';
import 'package:only_job/views/home/employer_profile.dart';
import 'package:only_job/views/home/job_details.dart';
import 'package:only_job/views/home/job_opening.dart';

class EmployerPositions extends StatefulWidget {
  const EmployerPositions({super.key});

  @override
  State<EmployerPositions> createState() => _EmployerPositionsState();
}

class _EmployerPositionsState extends State<EmployerPositions> {
  List<String> jobPositions = [];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Job Positions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: jobPositions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JobDetailsPage(jobTitle: jobPositions[index]),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    jobPositions[index],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobOpeningForm()),
          );
          if (result != null) {
            setState(() {
              jobPositions.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
