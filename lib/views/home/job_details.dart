import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  JobDetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
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
                  Text('Job Title: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Salary Range: ', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Location: ', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Skills Required: ', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Job Description:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Requirements:'),
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
