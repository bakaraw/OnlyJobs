import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String? uid;
  final String? degree;
  final String? university;
  final String? year;

  Education({required this.uid, required this.degree, required this.university, required this.year});

  factory Education.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Education(
      uid: doc.id,
      degree: data['degree'],
      university: data['university'],
      year: data['year'],
    );
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      uid: map['uid'],
      university: map['university'],
      degree: map['degree'],
      year: map['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'university': university,
      'degree': degree,
      'year': year,
    };
  }
}
