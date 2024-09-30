import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final String jobTitle;

  const JobDetailPage({Key? key, required this.jobTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: Center(
        child: Text(
          'Details for $jobTitle',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
