// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:only_job/views/home/employer_homepage.dart';
import 'package:only_job/views/home/employer_positions.dart';
import 'package:only_job/services/auth.dart';

class EmployerProfile extends StatefulWidget {
  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  AuthService _auth = AuthService();
  var listTileShape = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Company Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: listTileShape,
              title: const Row(
                children: [Text("Company "), Icon(Icons.business)],
              ),
              subtitle: const Text("BILAT"),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Website "), Icon(Icons.public)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Phone Number "), Icon(Icons.phone)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Email "), Icon(Icons.email)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Industry "), Icon(Icons.factory)],
              ),
              subtitle: Text("BILAT"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // pop all the screens and go to the login screen
                await _auth.signOut();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.white, // Button color
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.redAccent, // Button color
              ),
            ),
          ],
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
    );
  }
}
