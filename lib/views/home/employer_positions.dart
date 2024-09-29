import 'package:flutter/material.dart';
import 'package:only_job/views/home/employer_homepage.dart';
import 'package:only_job/views/home/employer_profile.dart';

class EmployerPositions extends StatefulWidget {
  const EmployerPositions({super.key});

  @override
  State<EmployerPositions> createState() => _EmployerPositionsState();
}

class _EmployerPositionsState extends State<EmployerPositions> {
  List<String> jobPositions = [];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Job Positions'), // App bar title
      ), // AppBar end

      // Main body of the page, wrapped in Padding for spacing
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // GridView to display job positions in boxes
        child: GridView.builder(
          // Grid configuration: 2 columns, 10px spacing
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of boxes per row
            crossAxisSpacing: 10.0, // Horizontal space between boxes
            mainAxisSpacing: 10.0, // Vertical space between boxes
          ), // SliverGridDelegateWithFixedCrossAxisCount end

          itemCount: jobPositions.length, // Number of job boxes to display
          itemBuilder: (context, index) {
            return GestureDetector(
              // When a job box is tapped
              onTap: () {
                // Navigate to JobDetailPage for the selected job
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailPage(
                      jobTitle: jobPositions[index], // Pass job title
                    ),
                  ),
                ); // Navigator.push end
              }, // onTap end

              // Job position box
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Box background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  border: Border.all(
                    color: Colors.blue, // Box border color (blue)
                    width: 2.0, // Border width
                  ), // Border end
                ), // BoxDecoration end

                // Center the text inside the job box
                child: Center(
                  child: Text(
                    jobPositions[index], // Display job title
                    style: const TextStyle(fontSize: 16), // Font size of text
                    textAlign: TextAlign.center, // Center-align text
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });

          // Navigate to the appropriate page
          switch (newIndex) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientHomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerPositions()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerProfile()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Positions',
            icon: Icon(Icons.business_outlined),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Applicants',
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Menu',
            icon: Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        fixedColor: Colors.black,
      ),

      // FloatingActionButton to add new job positions
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // When the button is pressed, add a new job position
          setState(() {
            jobPositions.add('New Job Position ${jobPositions.length + 1}');
          }); // setState end
        }, // onPressed end

        child: const Icon(Icons.add), // Plus icon inside button
        backgroundColor: Colors.blue, // Background color of button
      ), // FloatingActionButton end
    ); // Scaffold end
  } // build end
} // _JobPositionPageState end

// Page to show details for a selected job position
class JobDetailPage extends StatelessWidget {
  final String jobTitle; // The title of the job to display

  const JobDetailPage({Key? key, required this.jobTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle), // Display the job title as the app bar title
      ), // AppBar end

      // Body displaying the details of the selected job
      body: Center(
        child: Text(
          'Details for $jobTitle', // Display job details text
          style: TextStyle(fontSize: 24), // Text size for details
        ),
      ),
    );
  }
}
