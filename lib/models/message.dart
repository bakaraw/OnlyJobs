import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final DateTime time;
  final String senderName;
  final String receiver;

  Message({
    required this.message,
    required this.time,
    required this.senderName,
    required this.receiver,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'time': time,
      'name': senderName,
      'receiver': receiver,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] ?? '',
      time: (map['time'] as Timestamp).toDate(),
      senderName: map['name'] ?? 'Unknown',
      receiver: map['receivername'] ?? 'Unknown',
    );
  }
}
