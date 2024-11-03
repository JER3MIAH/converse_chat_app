import 'dart:convert';
import 'package:converse/src/features/auth/data/user.dart';
import 'message.dart';

class Chat {
  final String id;
  final List<User> participants;
  final ChatMessage? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants.map((x) => x.toMap()).toList(),
      if (lastMessage != null) 'lastMessage': lastMessage?.toMap(),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
