import 'dart:developer';
import 'package:converse/src/core/core.dart';
import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:dartz/dartz.dart';

abstract class ChatService {
  Future<Either<Failure, List<Chat>>> getChats();
  Future<Either<Failure, dynamic>> archiveChats(List<String> chatIds);
  Future<Either<Failure, dynamic>> deleteChats(List<String> chatIds);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, List<ChatMessage>>> getMessages(String chatId);
  Future<Either<Failure, void>> createChat(Chat chat);
}

class ChatServiceImpl extends ChatService {
  final ApiClient client;
  ChatServiceImpl({
    required this.client,
  });

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final response = await client.get(
        chatEndpoints.getUsers,
      );
      log('Get users response: $response');
      final users = List<User>.from(
        (response.data['data']).map<User>(
          (x) => User.fromMap(x),
        ),
      );

      return right(users);
    } catch (err, stack) {
      log('Get users error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    try {
      final response = await client.get(
        chatEndpoints.getChats,
      );
      log('Get chats response: $response');
      final chats = List<Chat>.from(
        (response.data['data']).map<Chat>(
          (x) => Chat.fromMap(x),
        ),
      );

      return right(chats);
    } catch (err, stack) {
      log('Get chats error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> archiveChats(List<String> chatIds) async {
    try {
      final response = await client.patch(
        chatEndpoints.archiveChats,
        data: {"chatIds": chatIds},
      );
      log('archive chats response: $response');

      return right(null);
    } catch (err, stack) {
      log('archive chats error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteChats(List<String> chatIds) async {
    try {
      final response = await client.delete(
        chatEndpoints.deleteChats,
        data: {"chatIds": chatIds},
      );
      log('delete chats response: $response');

      return right(null);
    } catch (err, stack) {
      log('delete chats error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String chatId) async {
    try {
      final response = await client.get(
        chatEndpoints.getMessages,
        data: {"chatId": chatId},
      );
      log('Get messages response: $response');
      final messages = List<ChatMessage>.from(
        (response.data['data']).map<ChatMessage>(
          (x) => ChatMessage.fromMap(x),
        ),
      );

      return right(messages);
    } catch (err, stack) {
      log('Get messages error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createChat(Chat chat) async {
    try {
      final response = await client.post(
        chatEndpoints.createChat,
        data: chat.toMap(),
      );
      log('Create chat response: $response');
      return right(null);
    } catch (err, stack) {
      log('Create chat error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }
}
