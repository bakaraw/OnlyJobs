import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillsUploader extends StatefulWidget {
  @override
  _SkillsUploaderState createState() => _SkillsUploaderState();
}

class _SkillsUploaderState extends State<SkillsUploader> {
  final String gistUrl =
      'https://gist.githubusercontent.com/bakaraw/052818b5dc9f14866ec98e5901393537/raw/5b9b9ac7f0ec93c8a32ff1c0ccc9a4fa2469d8d3/skills.json';

  Future<List<String>> fetchSkillsFromGist(String gistUrl) async {
    final response = await http.get(Uri.parse(gistUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body); // Change to Map
      return List<String>.from(data['skills']); // Access the 'skills' list
    } else {
      throw Exception('Failed to load Gist');
    }
  }

  Future<void> saveSkillsToFirestore(List<String> skills) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('Skills').add({
      'skills': skills,
    });
  }

  Future<void> uploadSkills() async {
    try {
      List<String> skills = await fetchSkillsFromGist(gistUrl);
      await saveSkillsToFirestore(skills);
      print('Skills uploaded successfully!');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: uploadSkills,
        child: Text('Upload Skills to Firestore'),
      ),
    );
  }
}

