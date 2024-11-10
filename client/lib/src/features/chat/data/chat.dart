import 'dart:convert';
import 'package:converse/src/features/auth/data/user.dart';
import 'message.dart';

class Chat {
  final String id;
  final List<User> participants;
  final ChatMessage? lastMessage;
  final bool isArchived;
  final int unreadMessages;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.isArchived = false,
    this.unreadMessages=0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants.map((x) => x.toMap()).toList(),
      if (lastMessage != null) 'lastMessage': lastMessage?.toMap(),
      'isArchived': isArchived,
      'unreadMessages': unreadMessages,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      participants: List<User>.from(
        (map['participants']).map<User>(
          (x) => User.fromMap(x as Map<String, dynamic>),
        ),
      ),
      lastMessage: map['lastMessage'] == null
          ? null
          : ChatMessage.fromMap(map['lastMessage'] as Map<String, dynamic>),
      isArchived: map['isArchived'],
      unreadMessages: map['unreadMessages'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  Chat copyWith({
    String? id,
    List<User>? participants,
    ChatMessage? lastMessage,
    bool? isArchived,
    int? unreadMessages,
  }) {
    return Chat(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      isArchived: isArchived ?? this.isArchived,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }
}
