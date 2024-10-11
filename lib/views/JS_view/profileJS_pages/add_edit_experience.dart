import 'package:flutter/material.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/models/experience.dart';
import 'package:only_job/views/constants/constants.dart';
import 'dart:developer';

class AddExperiencePage extends StatefulWidget {
  final Experience? experience; // Optional existing experience entry

  const AddExperiencePage({Key? key, this.experience}) : super(key: key);

  @override
  _AddExperiencePageState createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  late AuthService _auth;
  late UserService _userService;

  // Controllers for the text fields
  late TextEditingController _companyNameController;
  late TextEditingController _positionController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if editing
    if (widget.experience != null) {
      _startDateController = TextEditingController(
          text: widget.experience!.startDate.toString() ?? '');
      _endDateController = TextEditingController(
          text: widget.experience!.endDate.toString() ?? '');
      _companyNameController =
          TextEditingController(text: widget.experience!.company ?? '');
      _locationController =
          TextEditingController(text: widget.experience!.location ?? '');
      _positionController =
          TextEditingController(text: widget.experience!.title ?? '');
      _descriptionController =
          TextEditingController(text: widget.experience!.description ?? '');
      _selectedStartDate = widget.experience!.startDate;
      _selectedEndDate = widget.experience!.endDate;
    } else {
      _companyNameController = TextEditingController();
      _locationController = TextEditingController();
      _positionController = TextEditingController();
      _descriptionController = TextEditingController();
      _startDateController = TextEditingController();
      _endDateController = TextEditingController();
    }

    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _startDateController.dispose();
    _endDateController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Save the experience entry and return it to the previous screen
  void _saveExperience() {
    if (_formKey.currentState!.validate()) {
      _userService.addExperience(
        _companyNameController.text,
        _positionController.text,
        _descriptionController.text,
        _locationController.text,
        _selectedStartDate!,
        _selectedEndDate!,
      );

      Navigator.pop(context); // Return the data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.experience == null ? 'Add Experience' : 'Edit Experience'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start Date field
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your position';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _selectedStartDate == null
                      ? _startDateController.text
                      : "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}",
                ),
                decoration: InputDecoration(labelText: 'Start Date'),
                keyboardType: TextInputType.datetime,
                onTap: () => _selectStartDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // End Date field
              TextFormField(
                controller: TextEditingController(
                  text: _selectedEndDate == null
                      ? _endDateController.text
                      : "${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}",
                ),
                decoration: InputDecoration(labelText: 'End Date'),
                keyboardType: TextInputType.datetime,
                onTap: () => _selectEndDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Position field

              // Save button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateExperience() {
    log('start date: $_selectedStartDate');

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        _userService.updateExperience(
          _companyNameController.text,
          _positionController.text,
          _descriptionController.text,
          _locationController.text,
          _selectedStartDate!,
          _selectedEndDate!,
          widget.experience!.uid!,
        );
      } catch (e) {
        log("Error updating experience for user ${_auth.getCurrentUserId()}: $e");
        rethrow;
      }

      Navigator.pop(context); // Return the data
    }
  }

  void _deleteExperience() {
    try {
      _userService.deleteExperience(widget.experience!.uid!);
    } catch (e) {
      log("Error deleting experience for user ${_auth.getCurrentUserId()}: $e");
      rethrow;
    }

    Navigator.pop(context); // Return the data
  }

  List<Widget> buildButtons() {
    if (widget.experience == null) {
      return [
        Flexible(
          child: ElevatedButton(
            onPressed: _saveExperience,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.blue,
            ),
            child: const Text('Save'),
          ),
        ),
      ];
    } else {
      log('Editing experience');
      return [
        Flexible(
            child: ElevatedButton(
          onPressed: _deleteExperience,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: backgroundwhite,
            minimumSize: Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Delete'),
        )),
        smallSizedBox_W,
        Flexible(
            child: ElevatedButton(
          onPressed: _updateExperience,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: backgroundwhite,
            minimumSize: const Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Save'),
        )),
      ];
    }
  }
}
