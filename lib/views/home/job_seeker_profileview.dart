import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/models/education.dart';
import 'package:only_job/models/certification.dart';
import 'package:only_job/models/experience.dart';
import 'package:only_job/services/job_service.dart';

class ProfileScreen extends StatefulWidget {
  String? uid;
  String? jobUid;
  ProfileScreen({super.key, required this.uid, required this.jobUid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthService _auth;
  late UserService _applicantService;
  late UserData _applicantData;
  late List<Education>? _education;
  late List<Certification>? _certifications;
  late List<Experience>? _experiences;
  bool _isLoading = true;
  late JobService _jobService;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _applicantService = UserService(uid: widget.uid!);
    _jobService = JobService(uid: widget.uid!);
    _getApplicantData();
  }

  void _getApplicantData() async {
    _applicantData = await _applicantService.getUserById(widget.uid!);
    _education = await _applicantService.getEducation();
    _certifications = await _applicantService.getCertifications();
    _experiences = await _applicantService.getExperience();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: secondarycolor,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text("Job Seeker's Profile"),
              titleTextStyle: headingStyle_white,
              backgroundColor: primarycolor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_applicantData
                              .profilePicture!), // Replace with actual image
                        ),
                        SizedBox(height: 10),
                        Text(
                          _applicantData.name!,
                          style: usernameStyle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _applicantData.gender!,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Personal Info Card
                  InfoSection(
                    title: 'Personal Info',
                    children: [
                      InfoCard(
                        icon: Icons.cake_outlined,
                        text:
                            'Birthdate: ${DateFormat('MMM. d, y').format(_applicantData.birthDate!)}',
                      ),
                      InfoCard(
                        icon: Icons.home_outlined,
                        text: 'Address: ${_applicantData.address!}',
                      ),
                    ],
                  ),

                  // Contact Info Card
                  InfoSection(
                    title: 'Contact Info',
                    children: [
                      InfoCard(
                        icon: Icons.email_outlined,
                        text: 'Email: ${_applicantData.email!}',
                      ),
                      InfoCard(
                        icon: Icons.phone_outlined,
                        text: 'Phone: ${_applicantData.phone!}',
                      ),
                      if (_applicantData.website != null &&
                          _applicantData.website!.isNotEmpty)
                        InfoCard(
                          icon: Icons.web_outlined,
                          text: 'Website: ${_applicantData.website!}',
                        ),
                      if (_applicantData.website == null ||
                          _applicantData.website!.isEmpty)
                        InfoCard(
                          icon: Icons.web_outlined,
                          text: 'Website: Not provided',
                        ),
                    ],
                  ),

                  // Education and Skills Info Card
                  InfoSection(
                    title: 'Education and Skills',
                    children: [
                      ..._showEducation(),
                      ..._showExperiences(),
                      Column(
                        children: [
                          ..._showCertificates(),
                        ],
                      ),
                      if (_applicantData.skills != null)
                        if (_applicantData.skills!.isNotEmpty)
                          for (var skill in _applicantData.skills!)
                            InfoCard(
                              icon: Icons.build_outlined,
                              text: 'Skills: ${skill}',
                            ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Adjusts spacing
                children: [
                  SizedBox(
                    width: 100, // Set the desired width
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Action for the first button
                        _jobService.acceptApplicant(
                            widget.jobUid!, widget.uid!);

                        Navigator.of(context).pop();
                      },
                      backgroundColor: Colors.green,
                      heroTag: 'btn1',
                      label:
                          Text('Accept', style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100, // Set the desired width
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        // Action for the second button
                        _jobService.deleteApplicant(
                            widget.jobUid!, widget.uid!);
                        Navigator.of(context).pop();
                      },
                      backgroundColor: Colors.red,
                      heroTag: 'btn2',
                      label:
                          Text('Reject', style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  List<Widget> _showEducation() {
    List<Widget> educationWidgets = [];

    if (_education == null) {
      return educationWidgets;
    }

    for (var edu in _education!) {
      educationWidgets.add(
        InfoCard(
          icon: Icons.school_outlined,
          text: 'Education: ${edu.degree} at ${edu.university}',
        ),
      );
    }
    return educationWidgets;
  }

  List<Widget> _showExperiences() {
    List<Widget> experienceWidget = [];

    if (_experiences == null) {
      return experienceWidget;
    }

    for (var edu in _experiences!) {
      experienceWidget.add(
        InfoCard(
          icon: Icons.work,
          text: 'Experiences: ${edu.company}',
        ),
      );
    }
    return experienceWidget;
  }

  List<Widget> _showCertificates() {
    List<Widget> certificateWidget = [];

    if (_certifications == null) {
      return certificateWidget;
    }

    for (var edu in _certifications!) {
      certificateWidget.add(
        Image.network(edu.attachedFile!),
      );
      certificateWidget.add(
        InfoCard(
          icon: Icons.card_membership_outlined,
          text: 'Certification: ${edu.certificationName}',
        ),
      );
    }
    return certificateWidget;
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Column(children: children),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: primarycolor,
            ),
            SizedBox(width: 16),
            Text(
              text,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
