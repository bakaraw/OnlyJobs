import 'package:flutter/material.dart';

class JobOpeningForm extends StatefulWidget {
  @override
  _JobOpeningFormState createState() => _JobOpeningFormState();
}

class _JobOpeningFormState extends State<JobOpeningForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _salaryRangeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job Opening'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _salaryRangeController,
                decoration: InputDecoration(labelText: 'Salary Range'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _skillsRequiredController,
                decoration: InputDecoration(labelText: 'Skills Required'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _jobDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Job Description'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _requirementsController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Requirements'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Create Job Opening'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
