import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_certification.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_education.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_experience.dart';
import 'package:only_job/views/JS_view/profileJS_pages/add_edit_skills.dart';
import 'package:only_job/views/JS_view/profileJS_pages/edit_profile.dart';
import 'dart:io';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:intl/intl.dart';
import 'package:only_job/models/education.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthService _auth;
  late UserService _userService;
  List<Education> educationList = [];
  List<Map<String, String>> experienceList = [];
  List<Map<String, String>> certificationList = [];
  List<String> skills = [];

  // Stored Sample Job
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
    fetchEducationData();
  }

  Future<void> fetchEducationData() async {
    List<Education> fetchedEducationList =
        await _userService.getEducationList();
    setState(() {
      educationList = fetchedEducationList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: _userService.userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.hasData) {
            skills = snapshot.data!.skills!.cast<String>();
            return buildPage(snapshot.data!);
          }

          return const Loading();
        });
  }

  Widget buildPage(UserData userData) {
    String formattedBirthdate = userData.birthDate != null
        ? DateFormat('MMMM d, yyyy').format(userData.birthDate!)
        : '';

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
                          "Profile Information",
                          style: headingStyle,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            EditContactInfo(userData);
                          },
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
                    buildContactField('Full Name', userData.name ?? ''),
                    buildContactField('Gender', userData.gender ?? ''),
                    buildContactField('Birthdate', formattedBirthdate ?? ''),
                    buildContactField('Phone Number', userData.phone ?? ''),
                    buildContactField('Address', userData.address ?? ''),
                    buildContactField(
                        'Website',
                        userData.website?.isNotEmpty == true
                            ? userData.website!
                            : 'Not set'),
                    buildContactField('Email', userData.email ?? ''),

                    mediumSizedBox_H,
                    Divider(thickness: 2),
                    mediumSizedBox_H,

                    // Education Section
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
                          Education education = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      education.university ?? "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      education.degree ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      education.year ?? "",
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
                      onTap: AddOrEditExperience,
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
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    mediumSizedBox_H,
                    Divider(thickness: 2),
                    mediumSizedBox_H,

                    // Certification Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Certifications",
                        style: headingStyle,
                      ),
                    ),
                    smallSizedBox_H,

                    GestureDetector(
                      onTap:
                          AddOrEditCertification, // For adding new certification
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add Certification",
                            style: addinfotxtstyle,
                          ),
                        ],
                      ),
                    ),
                    // Display certification entries with labels and edit button
                    smallSizedBox_H,
                    if (certificationList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            certificationList.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> certification = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      certification['certificationName'] ?? "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      certification['year'] ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    if (certification['attachedFile'] != null)
                                      Text(
                                        "File attached",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green.shade700),
                                      ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Edit the selected certification entry
                                    AddOrEditCertification(
                                        certification, index);
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

                    // Skills Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Skills",
                        style: headingStyle,
                      ),
                    ),
                    smallSizedBox_H,

                    GestureDetector(
                      onTap: addOrEditSkills, // Navigate to AddSkillsPage
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add Skills",
                            style: addinfotxtstyle,
                          ),
                        ],
                      ),
                    ),

                    smallSizedBox_H,

                    // Display added skills with remove buttons
                    if (skills.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        children: skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            backgroundColor: Colors.blue[100],

                            //For displaying cancel button on each skills
                            // deleteIcon: Icon(Icons.cancel, color: Colors.red),
                            // onDeleted: () => removeSkill(skill),
                          );
                        }).toList(),
                      ),

                    // LOGOUT
                    mediumSizedBox_H,
                    ElevatedButton(
                      onPressed: () {
                        // Implement logout functionality
                        _auth.signOut();
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

  // Helper method to build each contact field
  Widget buildContactField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              enabled: false,
              hintText: value,
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  // Allows user to pick image from the gallery
  Future<void> PickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = pickedFile;
      }
    });
  }

  // Method to edit contact information
  void EditContactInfo(UserData userData) async {
    final updatedContactInfo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactInfoPage(userData: userData),
      ),
    );
  }

  // Method to add or edit education entry
  void AddOrEditEducation([Education? educationToEdit, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEducationPage(education: educationToEdit),
      ),
    );
    if (result != null && result is Education) {
      Education resultEducation = result;
      setState(() {
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

  // Method to add or edit certification entry
  void AddOrEditCertification(
      [Map<String, String>? certificationToEdit, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddCertificationPage(certification: certificationToEdit),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        if (index != null) {
          // Edit existing entry
          certificationList[index] = result;
        } else {
          // Add new entry
          certificationList.add(result);
        }
      });
    }
  }

// Method to add or edit skills
  void addOrEditSkills() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSkillsPage(selectedSkills: skills),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        skills = result; // Update skills with the selected ones
      });
    }
  }

  // Remove a skill from the profile
  void removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }
}
