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
      'senderName': senderName,
      'receiver': receiver,
    };
  }

  static Message fromMap(Map<String, dynamic> data) {
    return Message(
      message: data['message'] as String,
      time: (data['time'] as Timestamp).toDate(),
      senderName: data['senderName'] as String,
      receiver: data['receiver'] as String,
    );
  }
}