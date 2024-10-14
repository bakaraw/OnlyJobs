class Experience {
  final String? uid;
  final String? company;
  final String? title;
  final String? description;
  final String? location;
  final DateTime? startDate;
  final DateTime? endDate;

  Experience({
    required this.uid,
    required this.company,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  // from qury snapshot
  factory Experience.fromDocument(doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Experience(
      uid: doc.id,
      company: data['company'],
      title: data['title'],
      description: data['description'],
      location: data['location'],
      startDate: data['startDate'],
      endDate: data['endDate'],
    );
  }
  
}
