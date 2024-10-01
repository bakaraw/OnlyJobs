import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

class AddEducationPage extends StatefulWidget {
  final Map<String, String>? education; // Optional existing education entry

  const AddEducationPage({Key? key, this.education}) : super(key: key);

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if editing
    _degreeController =
        TextEditingController(text: widget.education?['degree'] ?? '');
    _institutionController =
        TextEditingController(text: widget.education?['institution'] ?? '');
    _yearController =
        TextEditingController(text: widget.education?['year'] ?? '');
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // Save the education entry and return it to the previous screen
  void _saveEducation() {
    if (_formKey.currentState!.validate()) {
      final educationData = {
        'institution': _institutionController.text,
        'degree': _degreeController.text,
        'year': _yearController.text,
      };
      Navigator.pop(context, educationData); // Return the data
    }
  }

  // Delete the education entry and return null to indicate deletion
  void _deleteEducation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Education'),
          content:
              Text('Are you sure you want to delete this education entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, null);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.education == null ? 'Add Education' : 'Edit Education'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institution field
              TextFormField(
                controller: _institutionController,
                decoration: InputDecoration(labelText: 'Institution'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the institution name';
                  }
                  return null;
                },
              ),
              mediumSizedBox_H,

              // Degree field
              TextFormField(
                controller: _degreeController,
                decoration: InputDecoration(labelText: 'Degree'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your degree';
                  }
                  return null;
                },
              ),
              mediumSizedBox_H,

              // Year field
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year of Graduation'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year of graduation';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
              extraLargeSizedBox_H,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Delete button (only visible if editing an existing entry)
                  if (widget.education != null)
                    ElevatedButton(
                      onPressed: _deleteEducation,
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: backgroundwhite,
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  smallSizedBox_W,
                  // Save button
                  ElevatedButton(
                    onPressed: _saveEducation,
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: backgroundwhite,
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
