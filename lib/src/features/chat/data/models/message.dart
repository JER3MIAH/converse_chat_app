import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/src/core/data/models/user_model.dart';

class ChatMessage {
  final UserModel sender;
  final UserModel receiver;
  final String message;
  final String messageType;
  final Timestamp timeStamp;

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.messageType,
    required this.timeStamp,
  });

  ChatMessage copyWith({
    UserModel? sender,
    UserModel? receiver,
    String? message,
    String? messageType,
    Timestamp? timeStamp,
  }) {
    return ChatMessage(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender.toMap(),
      'receiver': receiver.toMap(),
      'message': message,
      'messageType': messageType,
      'timeStamp': timeStamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: UserModel.fromMap(map['sender'] as Map<String, dynamic>),
      receiver: UserModel.fromMap(map['receiver'] as Map<String, dynamic>),
      message: map['message'] as String,
      messageType: map['messageType'] as String,
      timeStamp: map['timeStamp'] as Timestamp,
    );
  }
}
