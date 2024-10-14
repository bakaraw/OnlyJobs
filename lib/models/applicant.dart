class Applicant {
  final String uid;
  final String name;

  Applicant({required this.uid, required this.name,});

  factory Applicant.fromMap(Map<String, dynamic> data) {
    return Applicant(
      uid: data['uid'] as String,
      name: data['name'] as String,
    );
  }
}
