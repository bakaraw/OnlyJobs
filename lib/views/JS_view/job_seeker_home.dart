import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/models/user.dart';
import 'package:only_job/models/education.dart';
import 'package:only_job/views/constants/loading.dart';

class HomePage extends StatefulWidget {
  Function changePage;
  HomePage({super.key, required this.changePage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  late AuthService _auth;
  late UserService _userService;
  Education? education;
  List<dynamic>? skills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
    getSkills();
    getEducation();
  }

  void getEducation() async {
    final education = await _userService.getFirstUserEducation();
    setState(() {
      this.education = education;
      _isLoading = false;
    });
  }

  void getSkills() async {
    final skills = await _userService.getSkills();
    setState(() {
      this.skills = skills;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Loading() : Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'Logo.png',
                  height: 60,
                ),
                StreamBuilder<UserData>(
                  stream: _userService.userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.5,
                                alignment: Alignment.topRight,
                                child:
                                    _buildProfileModal(context, snapshot.data!),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: ClipOval(
                              child: Image.network(
                                  snapshot.data!.profilePicture!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
          // is skill empty? if yes, show text, else show container
          if (skills!.isEmpty)
               Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 60, // Fixed height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[100],
                      border: Border.all(color: Colors.amber[300]!, width: 1),
                    ),

                    padding: const EdgeInsets.symmetric(
                        horizontal: 16), // Optional padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Align text to the left and button to the right
                      children: [
                        Text(
                          'Set up profile to get started',
                          style: TextStyle(
                              fontSize: 16), // Customize the text style
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.changePage(0);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Text(
                            'Set-up',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomBodyWidget(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileModal(BuildContext context, UserData userData) {
    final skillsString = userData.skills!.map((skill) => '- $skill').join('\n');
    return Container(
      decoration: const BoxDecoration(
        color: backgroundwhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: Image.network(
                      userData.profilePicture!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (education != null)
                        Text(
                          education!.degree!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      if (education == null)
                        const Text(
                          'No education details',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Skills:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (skillsString.isNotEmpty)
              Text(
                skillsString,
                style: TextStyle(fontSize: 16),
              ),
            if (skillsString.isEmpty)
              const Text(
                'No skills added',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Text(
              'Sample Text',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
