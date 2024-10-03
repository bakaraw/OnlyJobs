import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo on the left
                Image.asset(
                  'Logo.png',
                  height: 60,
                ),
                // Clickable profile picture on the right
                GestureDetector(
                  onTap: () {
                    // Show the modal when the profile picture is tapped
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.5, // Control modal height
                          alignment: Alignment.topRight,
                          child: _buildProfileModal(context),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/profile_picture.png'), // Replace with your profile image
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          // Expanded area with scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Multiple CustomBodyWidgets
                  for (int i = 0; i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomBodyWidget(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modal content with user's full name, education, and skills
  Widget _buildProfileModal(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundwhite, // Background color of the modal
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the small bar at the top center of the modal
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Color of the bar
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20), // Space below the bar

            // Row with profile picture and name/education
            Row(
              children: [
                // Profile picture on the left
                CircleAvatar(
                  radius: 40, // Medium-sized profile picture
                  backgroundImage: AssetImage(
                      'assets/profile_picture.png'), // Replace with your profile image
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 16), // Space between profile picture and text

                // Expanded Column with name and education on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe', // Replace with actual full name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bachelor of Science in Computer Science', // Replace with actual education
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space between row and other content

            // Skills section
            Text(
              'Skills:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '- Flutter Development\n- Firebase\n- UI/UX Design', // Replace with actual skills
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for the body area
class CustomBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Set width for medium size
      height: 400, // Set height for medium size
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2), // Add border
        borderRadius: BorderRadius.circular(10), // Rounded corners
        color: Colors.white, // Background color of the container
      ),
      child: Stack(
        children: [
          // Sample text at the bottom left
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Text(
              'Sample Text', // Replace with your desired text
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
