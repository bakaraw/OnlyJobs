import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Send Message',
                style: appbarstyle,
              ))
        ],
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
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with actual image
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Beatrice Colon',
                    style: usernameStyle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '24, Female',
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
                  text: 'Birthdate: January 1, 2000',
                ),
                InfoCard(
                  icon: Icons.home_outlined,
                  text: 'Address: 123 Street, City',
                ),
              ],
            ),

            // Contact Info Card
            InfoSection(
              title: 'Contact Info',
              children: [
                InfoCard(
                  icon: Icons.email_outlined,
                  text: 'Email: beatrice@example.com',
                ),
                InfoCard(
                  icon: Icons.phone_outlined,
                  text: 'Phone: +123 456 7890',
                ),
                InfoCard(
                  icon: Icons.web_outlined,
                  text: 'Website: www.example.com',
                ),
              ],
            ),

            // Education and Skills Info Card
            InfoSection(
              title: 'Education and Skills',
              children: [
                InfoCard(
                  icon: Icons.school_outlined,
                  text: 'Education: B.Sc. in Product Design',
                ),
                InfoCard(
                  icon: Icons.card_membership_outlined,
                  text: 'Certification: Certified UX Designer',
                ),
                InfoCard(
                  icon: Icons.build_outlined,
                  text: 'Skills: UX/UI Design, Prototyping, Wireframing',
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
