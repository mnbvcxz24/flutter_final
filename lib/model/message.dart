import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderDisplayName;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderDisplayName,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderDisplayName': senderDisplayName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
