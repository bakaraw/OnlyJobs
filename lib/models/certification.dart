import 'package:cloud_firestore/cloud_firestore.dart';

class Certification {
  final String? uid;
  final String? certificationName;
  final String? date;
  final String? attachedFile;
  
  Certification({this.uid, this.certificationName, this.date, this.attachedFile});

  // from qury snapshot
  factory Certification.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Certification(
      uid: doc.id,
      certificationName: data['certificationName'],
      date: data['date'],
      attachedFile: data['attachedFile'],
    );
  }
}
