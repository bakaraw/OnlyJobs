import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:only_job/services/retrieve_skills.dart';
import 'package:only_job/views/home/common/search_skills.dart';
import 'package:only_job/services/job_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:only_job/services/file_service.dart';
import 'package:only_job/services/file_service.dart';
import 'package:only_job/views/constants/constants.dart';

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

  String? _selectedJobType;
  final List<String> _jobTypes = ['Full Time', 'Part Time', 'Contract'];

  FileService _fileUploader = FileService();
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  String _error = '';
  bool _loading = false;

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

  Future<void> _pickImage() async {
    final pickedFile = await _fileUploader.selectFile();
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
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
              GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          BorderRadius.circular(10), // Make the border rounded
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Clip the child to match the rounded border
                      child: _image == null
                          ? Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file),
                                    SizedBox(width: 10),
                                    Text('Select Image')
                                  ]),
                            )
                          : Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )),
              const SizedBox(height: 16),
              Text(_error, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              TextFormField(
                validator: _validator,
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: _validator,
                controller: _jobDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Job Description'),
              ),
              const SizedBox(height: 16),
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
              DropdownButtonFormField<String>(
                value: _selectedJobType,
                decoration: InputDecoration(labelText: 'Job Type'),
                items: _jobTypes.map((String jobType) {
                  return DropdownMenuItem<String>(
                    value: jobType,
                    child: Text(jobType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJobType = newValue;
                  });
                },
                validator: _validator,
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skills Required'),
                  SizedBox(height: 8),
                  for (String skill in selectedSkills)
                    Chip(
                      label: Text("$skill"),
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
                decoration:
                    InputDecoration(labelText: 'Additional Requirements'),
              ),
              SizedBox(height: 10),
              Text(_skillsError, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {

                  if (selectedSkills.isEmpty) {
                    setState(() {
                      _skillsError = 'Enter Skills Required';
                    });
                  }

                  if (_image == null) {
                    setState(() {
                      _error = 'Please select an image';
                    });
                  }

                  var url = await _fileUploader.uploadFileToFirebase(uid);

                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate() &&
                      selectedSkills.isNotEmpty &&
                      _image != null) {
                    String jobTitle = _jobTitleController.text;
                    JobService(uid: uid).addJobOpening(
                        _jobTitleController.text,
                        _jobDescriptionController.text,
                        _locationController.text,
                        int.parse(_minSalaryRangeController.text),
                        int.parse(_maxSalaryRangeController.text),
                        _selectedJobType!,
                        _requirementsController.text,
                        selectedSkills,
                        url!);

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
