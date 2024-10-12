import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:only_job/services/retrieve_skills.dart';
import 'package:only_job/views/home/common/search_skills.dart';
import 'package:only_job/services/job_service.dart';

class JobOpeningForm extends StatefulWidget {
  @override
  _JobOpeningFormState createState() => _JobOpeningFormState();
}

class _JobOpeningFormState extends State<JobOpeningForm> {
  late List<String> skills = [];
  List<String> selectedSkills = [];
  String _skillsError = '';
  late AuthService _auth;
  late String uid;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _minSalaryRangeController =
      TextEditingController();
  final TextEditingController _maxSalaryRangeController =
      TextEditingController();
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
    _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    List<String> fetchedSkills =
        await RetrieveSkills().retrieveSkillsFromFirestore();
    setState(() {
      skills = fetchedSkills;
    });
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Value';
    }
    return null;
  }

  Future<void> _navigateAndSelectSkill(BuildContext context) async {
    final selectedSkill = await showSearch<String>(
      context: context,
      delegate: SearchSkills(skills: skills, addSkills: addSkills),
    );

    if (selectedSkill != null) {
      setState(() {
        _skillsRequiredController.text = selectedSkill;
      });
    }
  }

  void addSkills(String skill) {
    setState(() {
      selectedSkills.add(skill);
    });
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
                validator: _validator,
                controller: _jobDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Job Description'),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: _validator,
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: _validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _minSalaryRangeController,
                      decoration: InputDecoration(labelText: 'Min Salary'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      validator: _validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _maxSalaryRangeController,
                      decoration: InputDecoration(labelText: 'Max Salary'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skills Required'),
                  SizedBox(height: 8),
                  for (String skill in selectedSkills)
                    Chip(
                      label: Text(skill),
                      onDeleted: () {
                        setState(() {
                          selectedSkills.remove(skill);
                        });
                      },
                    ),
                  ElevatedButton(
                    onPressed: () {
                      _navigateAndSelectSkill(context);
                    },
                    child: const Text("Add Skill"),
                  )
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _requirementsController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Requirements'),
              ),
              SizedBox(height: 10),
              Text(_skillsError, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (selectedSkills.isEmpty) {
                    setState(() {
                      _skillsError = 'Enter Skills Required';
                    });
                  }

                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate() &&
                      selectedSkills.isNotEmpty) {
                    String jobTitle = _jobTitleController.text;
                    JobService(uid: uid).addJobOpening(
                      _jobTitleController.text,
                      _jobDescriptionController.text,
                      _locationController.text,
                      int.parse(_minSalaryRangeController.text),
                      int.parse(_maxSalaryRangeController.text),
                      'Remote',
                      'IT',
                      selectedSkills,
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
