import 'package:flutter/material.dart';

class AddExperiencePage extends StatefulWidget {
  final Map<String, String>? experience; // Optional existing experience entry

  const AddExperiencePage({Key? key, this.experience}) : super(key: key);

  @override
  _AddExperiencePageState createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyAddressController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if editing
    _startDateController =
        TextEditingController(text: widget.experience?['startDate'] ?? '');
    _endDateController =
        TextEditingController(text: widget.experience?['endDate'] ?? '');
    _companyNameController =
        TextEditingController(text: widget.experience?['companyName'] ?? '');
    _companyAddressController =
        TextEditingController(text: widget.experience?['companyAddress'] ?? '');
    _positionController =
        TextEditingController(text: widget.experience?['position'] ?? '');
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _startDateController.dispose();
    _endDateController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  // Save the experience entry and return it to the previous screen
  void _saveExperience() {
    if (_formKey.currentState!.validate()) {
      final experienceData = {
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'companyName': _companyNameController.text,
        'companyAddress': _companyAddressController.text,
        'position': _positionController.text,
      };
      Navigator.pop(context, experienceData); // Return the data
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
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                keyboardType: TextInputType.datetime,
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
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Company Name field
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

              // Company Address field
              TextFormField(
                controller: _companyAddressController,
                decoration: InputDecoration(labelText: 'Company Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Position field
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
              SizedBox(height: 32),

              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: _saveExperience,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
