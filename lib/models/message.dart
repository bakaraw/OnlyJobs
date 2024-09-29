import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUid;
  final String receiverUid;
  final String messageContent;
  final DateTime timestamp;
  final String senderName;
  final String receiverName;


  Message({
    required this.senderUid,
    required this.receiverUid,
    required this.messageContent,
    required this.timestamp,
    required this.senderName,
    required this.receiverName,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'messageContent': messageContent,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
      'receiverName': receiverName,
    };
  }
}