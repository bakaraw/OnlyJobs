import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';

class JobOpeningForm extends StatefulWidget {
  @override
  _JobOpeningFormState createState() => _JobOpeningFormState();
}

class _JobOpeningFormState extends State<JobOpeningForm> {
  late AuthService _auth;
  late String uid;
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
  void initState() {
    super.initState();
    _auth = AuthService();
    uid = _auth.getCurrentUserId()!;
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Value';
    }
    return null;
  }

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
                validator: _validator,
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
                validator: _validator,
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
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    String jobTitle = _jobTitleController.text;
                    UserService(uid: uid).addJobOpening(
                      _jobTitleController.text,
                      _jobDescriptionController.text,
                      20,
                      49,
                      'Remote',
                      'IT',
                      List<String>.from(['Python', 'Dart']),
                    );

                    Navigator.pop(context, jobTitle);
                  }
                },
                child: Text('Create Job Opening'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
