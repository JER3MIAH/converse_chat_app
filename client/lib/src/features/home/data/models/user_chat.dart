import 'package:converse/src/features/chat/data/models/message.dart';

class UserChat {
  final String id;
  final List<String> participants;
  final List<ChatMessage> messages;

  UserChat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory UserChat.fromMap(Map<String, dynamic> map) {
    List<ChatMessage> messages = [];
    for (var element in map['messages']) {
      messages.add(ChatMessage.fromMap(element));
    }
    return UserChat(
      id: map['id'] as String,
      participants: List<String>.from(
        (map['participants'] as List<String>),
      ),
      messages: messages,
    );
  }
}
