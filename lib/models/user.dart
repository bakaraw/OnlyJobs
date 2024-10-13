import 'package:only_job/models/education.dart';
import 'package:only_job/models/experience.dart';
import 'package:only_job/models/certification.dart';

class User {
  final String? uid;

  User({
    required this.uid,
  });
}

class UserData {
  final String? uid;
  final String? name;
  final String? email;
  final String? gender;
  final DateTime? birthDate;
  final String? phone;
  final String? address;
  final bool? isJobSeeker;
  final String? website;
  final bool? isUserNew;
  final String? profilePicture;
  List<dynamic>? skills; 
  List<Education>? education;
  List<Experience>? experience;
  List<Certification>? certifications;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.address,
    required this.isJobSeeker,
    required this.website,
    required this.isUserNew,
    required this.profilePicture,
    this.skills,
    this.education,
    this.experience,
    this.certifications
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'phone': phone,
      'address': address,
      'isJobSeeker': isJobSeeker,
      'website': website,
      'isUserNew': isUserNew,
      'profilePicture': profilePicture,
      'skills': skills,
    };
  }
}
