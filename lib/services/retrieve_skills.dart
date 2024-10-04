import 'package:cloud_firestore/cloud_firestore.dart';

class RetrieveSkills {
  Future<List<String>> retrieveSkillsFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('Skills').get();

    if (snapshot.docs.isNotEmpty) {
      var skillsDoc = snapshot.docs.first;
      List<String> skills = List<String>.from(skillsDoc['skills']);
      return skills;
    } else {
      return [];
    }
  }
}
