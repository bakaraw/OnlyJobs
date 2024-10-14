import 'package:flutter/material.dart';
import 'package:only_job/models/certification.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'dart:typed_data';
import 'package:only_job/services/file_service.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddCertificationPage extends StatefulWidget {
  final Certification? certification; // For editing existing certification

  AddCertificationPage({this.certification});

  @override
  _AddCertificationPageState createState() => _AddCertificationPageState();
}

class _AddCertificationPageState extends State<AddCertificationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _certificationNameController;
  late TextEditingController _yearController;
  //final ImagePicker _picker = ImagePicker();
  late AuthService _authService;
  late UserService _userService;

  FileService _fileUploader = FileService();

  dynamic _attachedFile;

  bool loading = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // If an existing certification is passed for editing, pre-populate the fields
    if (widget.certification != null) {
      _certificationNameController = TextEditingController();
      _yearController = TextEditingController();

      _certificationNameController.text =
          widget.certification!.certificationName ?? '';
      _yearController.text = widget.certification!.date! ?? '';

      if (widget.certification!.attachedFile != null) {
        _attachedFile = widget.certification!.attachedFile!;
      }
    } else {
      _certificationNameController = TextEditingController();
      _yearController = TextEditingController();
    }

    _authService = AuthService();
    _userService = UserService(uid: _authService.getCurrentUserId()!);
  }

  // Save the certification details
  void saveCertification() async {
    if (_formKey.currentState!.validate()) {
      // Create a certification map with the entered data
      setState(() {
        loading = true;
      });

      String? downloadUrl = await _fileUploader
          .uploadFileToFirebase(_authService.getCurrentUserId()!);

      String year = _selectedDate?.year.toString() ?? _yearController.text;
      await _userService.addCertification(
          _certificationNameController.text, year, downloadUrl);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundwhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.certification == null
            ? 'Add Certification'
            : 'Edit Certification'),
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
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? _yearController.text
                      : _selectedDate!.year.toString(),
                ),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onTap: () => _selectYear(context),
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
              const SizedBox(height: 16),

              // Attach File
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      _attachedFile = await _fileUploader.selectFile();

                      setState(() {});
                    },
                    icon: Icon(Icons.attach_file),
                    label: Text('Attach File'),
                  ),
                  SizedBox(width: 10),
                  if (_attachedFile != null) ...[
                    _attachedFile is Uint8List
                        ? Expanded(
                            child: Text(
                              _fileUploader.fileName ?? 'no file selected',
                              style: TextStyle(color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Expanded(
                            child: Text(
                              getFileNameFromUrl(_attachedFile),
                              style: TextStyle(color: Colors.green),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ],
              ),
              // If a file is attached, show its preview (image or file name)
              //if (_attachedFile != null) ...[
              //  SizedBox(height: 16),
              //  _attachedFile != null
              //      ? Image.memory(
              //          _attachedFile!,
              //          height: 100,
              //          width: 100,
              //          fit: BoxFit.cover,
              //        )
              //      : Text('No file attached'),
              //],
              if (_attachedFile != null) ...[
                SizedBox(height: 16),
                _attachedFile is Uint8List
                    ? Image.memory(
                        _attachedFile
                            as Uint8List, // Cast to Uint8List if needed
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const Text(' '),
                _attachedFile is String
                    ? Image.network(
                        _attachedFile as String, // Cast to String if needed
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const Text(' '),
              ],
              Spacer(),
              ..._buildButtons(),
              // Save Button
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    if (_attachedFile is String) {
      return [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {},
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
        ]),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: saveCertification,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent1,
            foregroundColor: backgroundwhite,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator()))
              : const Text('Save Certification'),
        ),
      ];
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? pickedYear = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
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

  String getFileNameFromUrl(String downloadUrl) {
    // Split the downloadUrl at the last '/' and take the last part
    return downloadUrl.split('/').last.split('2%2F').last.split('?').first;
  }
}
