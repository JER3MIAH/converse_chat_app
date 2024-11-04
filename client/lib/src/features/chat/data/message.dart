import 'dart:convert';

class ChatMessage {
  String id;
  String chatId;
  String text;
  String senderId;
  String receiverId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessage({
    this.id = '_',
    required this.chatId,
    required this.text,
    required this.senderId,
    required this.receiverId,
    this.createdAt,
    this.updatedAt,
  });

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? text,
    String? senderId,
    String? receiverId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'chatId': chatId,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] == null
          ? null
          : DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
