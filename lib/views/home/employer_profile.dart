// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:only_job/views/constants/constants.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/services/user_service.dart';
import 'package:only_job/views/constants/loading.dart';
import 'package:only_job/models/user.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:only_job/utils/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EmployerProfile extends StatefulWidget {
  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  late AuthService _auth;
  late UserService _userService;
  bool _editCompanyName = false;
  bool _editAddress = false;
  bool _editPhone = false;
  bool _editEmail = false;
  bool _editWebsite = false;

  bool _loadingName = false;
  bool _loadingAddress = false;
  bool _loadingPhone = false;
  bool _loadingEmail = false;
  bool _loadingWebsite = false;

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();

  Uint8List? _webImage;
  String? _imageLink;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _userService = UserService(uid: _auth.getCurrentUserId()!);
  }

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
    return StreamBuilder<UserData>(
      stream: _userService.userData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.hasData) {
          _companyNameController.text = snapshot.data!.name ?? '';
          _emailController.text = snapshot.data!.email ?? '';
          _phoneController.text = snapshot.data!.phone ?? '';
          _addressController.text = snapshot.data!.address ?? '';
          _imageLink = snapshot.data!.profilePicture ?? '';
          _loadImage();
          return profilePage(snapshot.data!);
        }

        return const Text("Error in retrieving user data");
      },
    );
  }

  NetworkImage? showPFP() {
    if (_imageLink != null && _imageLink!.isNotEmpty) {
      return NetworkImage(_imageLink!);
    }
    return null;
  }

void _loadImage() async {
  Uint8List? imageData = await _userService.fetchImageBytes(_imageLink ?? '');
  if (imageData != null) {
    _webImage = imageData;
    print('Image loaded successfully with ${imageData.length} bytes.');
  } else {
    print('Failed to load image data.');
  }
}

  Widget profilePage(UserData userData) {
    return Scaffold(
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: kIsWeb ? MemoryImage(_webImage!) : showPFP(),
                  child: _imageLink == null || _imageLink!.isEmpty
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () async {
                      if (kIsWeb) {
                        var image = await ImagePicker().getImageFromFiles();
                        String? link;
                        if (image != null) {
                          _webImage = image;
                        }

                        if (_webImage != null) {
                          link = await UserService(uid: userData.uid!)
                              .uploadImageFromBytes(_webImage!);
                          log('Image Link: $link');
                        }

                        if (link != null) {
                          await UserService(uid: userData.uid!)
                              .updateProfilePicture(link);
                        } else {
                          log('Image link is null');
                        }

                        log('Image: $_webImage');
                      } else if (!kIsWeb) {
                        File? image =
                            await ImagePicker().getImageFromGallery(context);
                        String? link;

                        if (image != null) {
                          link = await UserService(uid: userData.uid!)
                              .uploadImage(image);
                          log('Image Link: $link');
                        }

                        if (link != null) {
                          await UserService(uid: userData.uid!)
                              .updateProfilePicture(link);
                        } else {
                          log('Image link is null');
                        }
                      }
                    },
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
                        if (_editCompanyName) {
                          setState(() {
                            _loadingName = true;
                          });
                          await UserService(uid: userData.uid!).updateUserData(
                              _companyNameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _addressController.text);
                        }

                        setState(() {
                          _editCompanyName = !_editCompanyName;
                          _loadingName = false;
                        });
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
              subtitle: _editWebsite
                  ? TextFormField(
                      decoration: textFieldStyleSM,
                      controller: _websiteController,
                    )
                  : websiteLink(userData),
              trailing: _loadingWebsite
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          _loadingWebsite = true;
                        });

                        if (_editWebsite) {
                          await UserService(uid: userData.uid!)
                              .updateWebsite(_websiteController.text);
                        }

                        setState(() {
                          _editWebsite = !_editWebsite;
                          _loadingWebsite = false;
                        });
                      },
                      child: _editWebsite ? Text("Save") : Text("Edit"),
                    ),
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
                          await UserService(uid: userData.uid!).updateUserData(
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
                children: [Text("Address"), Icon(Icons.location_on)],
              ),
              subtitle: _editAddress
                  ? TextFormField(
                      decoration: textFieldStyleSM,
                      controller: _addressController,
                    )
                  : Text(_addressController.text),
              trailing: _loadingAddress
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        // explain the logic here
                        // if the user is in edit mode, then save the data
                        if (_editAddress) {
                          setState(() {
                            _loadingAddress = true;
                          });
                          await UserService(uid: userData.uid!).updateUserData(
                              _companyNameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _addressController.text);
                        }

                        setState(() {
                          _editAddress = !_editAddress;
                          _loadingAddress = false;
                        });
                      },
                      child: _editAddress ? Text("Save") : Text("Edit")),
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
                        // explain the logic here
                        // if the user is in edit mode, then save the data
                        if (_editEmail) {
                          setState(() {
                            _loadingEmail = true;
                          });

                          try {
                            _auth.updateEmail(_emailController.text);
                            UserService(uid: userData.uid!).updateUserData(
                                _companyNameController.text,
                                _emailController.text,
                                _phoneController.text,
                                _addressController.text);
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              log('Failed to update email: ${e.message}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to update email: ${e.message}')),
                              );
                            } else {
                              log('An error occurred: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('An error occurred: $e')),
                              );
                            }
                          }
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
  }

  Widget websiteLink(UserData userData) {
    if (userData.website == null || userData.website!.isEmpty) {
      return Text('Website not Specified');
    }
    return Text(userData.website!);
  }
}
