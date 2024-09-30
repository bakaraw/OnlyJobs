import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_education.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_experience.dart';
import 'dart:io';
import 'package:only_job/views/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, String>> educationList = []; // Store education entries
  List<Map<String, String>> experienceList = []; // Store experience entries
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Allows user to pick image from the gallery
  Future<void> PickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = pickedFile;
      }
    });
  }

  // Method to add or edit education entry
  void AddOrEditEducation(
      [Map<String, String>? educationToEdit, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEducationPage(education: educationToEdit),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        if (index != null) {
          // Edit existing entry
          educationList[index] = result;
        } else {
          // Add new entry
          educationList.add(result);
        }
      });
    }
  }

  // Method to add or edit experience entry
  void AddOrEditExperience(
      [Map<String, String>? experienceToEdit, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExperiencePage(experience: experienceToEdit),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        if (index != null) {
          // Edit existing entry
          experienceList[index] = result;
        } else {
          // Add new entry
          experienceList.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          largeSizedBox_H,
          Container(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: _profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            File(_profileImage!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: PickImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: accent1,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          mediumSizedBox_H,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contact Information",
                          style: headingStyle,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text('Edit'),
                        )
                      ],
                    ),
                    // Full Name
                    buildTextField("Full Name", "Name"),
                    smallSizedBox_H,

                    // Gender
                    buildTextField("Gender", "gender"),
                    smallSizedBox_H,

                    // Birthdate
                    buildTextField("Birthdate", "birthdate"),
                    smallSizedBox_H,

                    // Phone Number
                    buildTextField("Phone Number", "phone number"),
                    smallSizedBox_H,

                    // Address
                    buildTextField("Address", "address"),
                    smallSizedBox_H,

                    // Email Address
                    buildTextField("Email Address", "email"),

                    mediumSizedBox_H,
                    Divider(thickness: 2),
                    mediumSizedBox_H,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Education",
                        style: headingStyle,
                      ),
                    ),
                    smallSizedBox_H,
                    GestureDetector(
                      onTap: AddOrEditEducation,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add Education",
                            style: addinfotxtstyle,
                          ),
                        ],
                      ),
                    ),
                    // Display education entries with labels and edit button
                    smallSizedBox_H,
                    if (educationList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: educationList.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> education = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      education['institution'] ?? "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      education['degree'] ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      education['year'] ?? "",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Edit the selected education entry
                                    AddOrEditEducation(education, index);
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    mediumSizedBox_H,
                    Divider(thickness: 2),
                    mediumSizedBox_H,

                    // Experience Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Experience",
                        style: headingStyle,
                      ),
                    ),
                    smallSizedBox_H,

                    GestureDetector(
                      onTap: AddOrEditExperience, // For adding new experience
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add Experience",
                            style: addinfotxtstyle,
                          ),
                        ],
                      ),
                    ),

                    // Display experience entries with labels and edit button
                    smallSizedBox_H,
                    if (experienceList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: experienceList.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> experience = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      experience['companyName'] ?? "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      experience['position'] ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${experience['startDate']} - ${experience['endDate']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Edit the selected experience entry
                                    AddOrEditExperience(experience, index);
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    // LOGOUT
                    mediumSizedBox_H,
                    ElevatedButton(
                      onPressed: () {
                        // Implement logout functionality
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for text fields
  Widget buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        TextField(
          decoration: InputDecoration(
            enabled: false,
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
