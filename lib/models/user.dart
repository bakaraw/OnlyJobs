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

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.address,
    required this.isJobSeeker,
  });
}
