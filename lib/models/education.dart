import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String? degree;
  final String? university;
  final String? year;

  Education({required this.degree, required this.university, required this.year});

  factory Education.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Education(
      degree: data['degree'],
      university: data['university'],
      year: data['year'],
    );
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      university: map['university'],
      degree: map['degree'],
      year: map['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'university': university,
      'degree': degree,
      'year': year,
    };
  }
}
