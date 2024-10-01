import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCertificationPage extends StatefulWidget {
  final Map<String, String>?
      certification; // For editing existing certification

  AddCertificationPage({this.certification});

  @override
  _AddCertificationPageState createState() => _AddCertificationPageState();
}

class _AddCertificationPageState extends State<AddCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certificationNameController =
      TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  File? _attachedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // If an existing certification is passed for editing, pre-populate the fields
    if (widget.certification != null) {
      _certificationNameController.text =
          widget.certification!['certificationName'] ?? '';
      _yearController.text = widget.certification!['year'] ?? '';
      if (widget.certification!['attachedFile'] != null) {
        _attachedFile = File(widget.certification!['attachedFile']!);
      }
    }
  }

  // Pick file for certification (can be an image or PDF)
  Future<void> pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _attachedFile = File(pickedFile.path);
      });
    }
  }

  // Save the certification details
  void saveCertification() {
    if (_formKey.currentState!.validate()) {
      // Create a certification map with the entered data
      Map<String, String> certification = {
        'certificationName': _certificationNameController.text,
        'year': _yearController.text,
        'attachedFile': _attachedFile?.path ?? ''
      };

      // Pop and return the certification data back to the ProfileScreen
      Navigator.pop(context, certification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.certification == null
            ? 'Add Certification'
            : 'Edit Certification'),
        actions: [
          IconButton(
            onPressed: saveCertification,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Certification Name
              TextFormField(
                controller: _certificationNameController,
                decoration: InputDecoration(
                  labelText: 'Certification Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the certification name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Year
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Attach File
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickFile,
                    icon: Icon(Icons.attach_file),
                    label: Text('Attach File'),
                  ),
                  SizedBox(width: 10),
                  if (_attachedFile != null)
                    Expanded(
                      child: Text(
                        _attachedFile!.path.split('/').last,
                        style: TextStyle(color: Colors.green),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),

              // If a file is attached, show its preview (image or file name)
              if (_attachedFile != null) ...[
                SizedBox(height: 16),
                _attachedFile != null
                    ? Image.file(
                        _attachedFile!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Text('No file attached'),
              ],

              Spacer(),

              // Save Button
              ElevatedButton(
                onPressed: saveCertification,
                child: Text('Save Certification'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
