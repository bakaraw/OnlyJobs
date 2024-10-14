import 'package:flutter/material.dart';
import 'package:only_job/views/authenticate/sign_up_form.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/views/authenticate/employer_signup_form.dart';

class ClientOrEmployee extends StatelessWidget {
  ClientOrEmployee({super.key, required this.changePage});

  final Function changePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        leading: IconButton(
          onPressed: () {
            changePage(0);
          },
          icon: Icon(
            Icons.arrow_back,
            color: accent1,
          ),
        ),
      ),
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose your role',
                style: headingStyle_white,
              ),
              SizedBox(height: 30),
              buildRoleCard(
                context,
                image: 'JobSeeker_background_pic.jpg',
                buttonText: 'Employee',
                description:
                    'Find jobs, set your profile, and showcase your skills to potential employers.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpForm(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              buildRoleCard(
                context,
                image: 'Client_backgound_pic.jpg',
                buttonText: 'Employer',
                description:
                    'Post jobs, find skilled freelancers, and manage job applications easily.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ClientSignupForm(),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an Account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      changePage(2);
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: accent1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoleCard(BuildContext context,
      {required String image,
      required String buttonText,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4.0,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // Increased height
            ),
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black.withOpacity(0.5), // Dark overlay
            ),
          ),
          // Button and content
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: accent1,
                ),
                child: Text(buttonText),
              ),
            ),
          ),
          // Description text inside the card
          Positioned(
            bottom: 70,
            left: 16,
            right: 16,
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
