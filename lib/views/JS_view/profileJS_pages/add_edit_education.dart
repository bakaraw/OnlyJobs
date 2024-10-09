import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/models/education.dart';
import 'package:only_job/services/user_service.dart';

class AddEducationPage extends StatefulWidget {
  Education? education;
  String? uid;

  AddEducationPage({Key? key, this.education, this.uid}) : super(key: key);

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();
  late AuthService _auth;
  late UserService _userService;

  // Controllers for the text fields
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _yearController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
    // Initialize controllers with existing data if editing
    _degreeController =
        TextEditingController(text: widget.education?.degree ?? '');
    _institutionController =
        TextEditingController(text: widget.education?.university ?? '');
    _yearController = TextEditingController(text: widget.education?.year ?? '');
    //_yearFocusNode = FocusNode();
    //_yearFocusNode.addListener(() {
    //  if (!_yearFocusNode.hasFocus) {
    //    _selectYear(context);
    //  }
    //});
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
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _userService.addEducation(
        _institutionController.text,
        _degreeController.text,
        _selectedDate == null
            ? _yearController.text
            : _selectedDate!.year.toString(),
      );
      Navigator.pop(context); // Return the data
    }
  }

  void _updateEducation() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _userService.updateEducation(
        _institutionController.text,
        _degreeController.text,
        _selectedDate == null
            ? _yearController.text
            : _selectedDate!.year.toString(),
        widget.education!.uid!,
      );

      Navigator.pop(context); // Return the data
    }
  }

  // Delete the education entry and return null to indicate deletion
  void _deleteEducation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Education'),
          content:
              const Text('Are you sure you want to delete this education entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                _userService.deleteEducation(widget.education!.uid!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? _yearController.text
                      : _selectedDate!.year.toString(),
                ),
                decoration: const InputDecoration(labelText: 'Year of Graduation'),
                keyboardType: TextInputType.number,
                onTap: () => _selectYear(context),
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
                children: _buildButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    if (widget.education != null) {
      return [
        ElevatedButton(
          onPressed: _deleteEducation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: backgroundwhite,
            minimumSize: const Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Delete'),
        ),
        smallSizedBox_W,
        ElevatedButton(
          onPressed: _updateEducation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: backgroundwhite,
            minimumSize: const Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Save'),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: _saveEducation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: backgroundwhite,
            minimumSize: const Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Save'),
        ),
      ];
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? pickedYear = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              initialDate: _selectedDate ?? DateTime.now(),
              selectedDate: _selectedDate ?? DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null && pickedYear != _selectedDate) {
      setState(() {
        _selectedDate = pickedYear;
      });
    }
  }
}
