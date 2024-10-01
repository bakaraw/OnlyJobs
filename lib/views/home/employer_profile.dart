// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/models/user.dart';
import 'dart:developer';

class EmployerProfile extends StatefulWidget {
  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  AuthService _auth = AuthService();
  bool _editCompanyName = false;
  bool _editAddress = false;
  bool _editPhone = false;
  bool _editEmail = false;

  bool _loadingName = false;
  bool _loadingAddress = false;
  bool _loadingPhone = false;
  bool _loadingEmail = false;

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
    String? uid = _auth.getCurrentUserId();
    if (uid == null) {
      return const Text("User ID is null");
    }
    log('Employer Profile ${_auth.getCurrentUserId()}');
    return StreamBuilder<UserData>(
      stream: UserService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.hasData) {
          _companyNameController.text = snapshot.data!.name ?? '';
          _emailController.text = snapshot.data!.email ?? '';
          _phoneController.text = snapshot.data!.phone ?? '';
          _addressController.text = snapshot.data!.address ?? '';
          return profilePage(snapshot.data!);
        }

        return const Text("Error in retrieving user data");
      },
    );
  }

  Widget profilePage(UserData userData) => Scaffold(
        appBar: AppBar(
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
                subtitle: _editCompanyName
                    ? TextFormField(
                        decoration: textFieldStyleSM,
                        controller: _companyNameController,
                      )
                    : Text(_companyNameController.text),
                trailing: _loadingName
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          _updateUserData(userData.uid!);
                        },
                        child: _editCompanyName ? Text("Save") : Text("Edit")),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                shape: listTileShape,
                title: Row(
                  children: [Text("Website "), Icon(Icons.public)],
                ),
                subtitle: Text("Not Specified"),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                shape: listTileShape,
                title: Row(
                  children: [Text("Phone Number "), Icon(Icons.phone)],
                ),
                subtitle: _editPhone
                    ? TextFormField(
                        decoration: textFieldStyleSM,
                        controller: _phoneController,
                      )
                    : Text(_phoneController.text),
                trailing: _loadingPhone
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            _loadingPhone = true;
                          });
                          // explain the logic here
                          // if the user is in edit mode, then save the data
                          if (_editPhone) {
                            await UserService(uid: userData.uid!)
                                .updateUserData(
                                    _companyNameController.text,
                                    _emailController.text,
                                    _phoneController.text,
                                    _addressController.text);
                          }

                          setState(() {
                            _editPhone = !_editPhone;
                            _loadingPhone = false;
                          });
                        },
                        child: _editPhone ? Text("Save") : Text("Edit")),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                shape: listTileShape,
                title: Row(
                  children: [Text("Email "), Icon(Icons.email)],
                ),
                subtitle: _editEmail
                    ? TextFormField(
                        decoration: textFieldStyleSM,
                        controller: _emailController,
                      )
                    : Text(_emailController.text),
                trailing: _loadingEmail
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            _loadingEmail = true;
                          });
                          // explain the logic here
                          // if the user is in edit mode, then save the data
                          if (_editEmail) {
                            await UserService(uid: userData.uid!)
                                .updateUserData(
                                    _companyNameController.text,
                                    _emailController.text,
                                    _phoneController.text,
                                    _addressController.text);
                          }

                          setState(() {
                            _editEmail = !_editEmail;
                            _loadingEmail = false;
                          });
                        },
                        child: _editEmail ? Text("Save") : Text("Edit")),
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
      );

  void _updateUserData(String uid) async {
    setState(() {
      _loadingName = true;
    });
    // explain the logic here
    // if the user is in edit mode, then save the data
    if (_editCompanyName) {
      await UserService(uid: uid).updateUserData(
          _companyNameController.text,
          _emailController.text,
          _phoneController.text,
          _addressController.text);
    }

    setState(() {
      _editCompanyName = !_editCompanyName;
      _loadingName = false;
    });
  }
}
