import 'dart:developer';

import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/core/network/socket_service.dart';
import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/chat/data/models.dart';
import 'package:converse/src/features/chat/logic/services/chat_service.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider(chatService: sl(), socketService: sl());
});

class ChatProvider extends ChangeNotifier {
  final ChatService chatService;
  final SocketService socketService;
  ChatProvider({
    required this.chatService,
    required this.socketService,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<User> _users = [];
  List<User> get users => _users;

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  final List<Chat> _selectedChats = [];
  List<Chat> get selectedChats => _selectedChats;

  // final List<Chat> _archivedChats = [];
  // List<Chat> get archivedChats => _archivedChats;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
  }

  void setUsers(List<User> value, {bool updateState = true}) {
    _users = value;
    if (updateState) notifyListeners();
  }

  void setChats(List<Chat> value, {bool updateState = true}) {
    _chats = value;
    if (updateState) notifyListeners();
  }

  void setMessages(List<ChatMessage> value, {bool updateState = true}) {
    _messages = value;
    if (updateState) notifyListeners();
  }

  void selectChat(Chat value) {
    if (_selectedChats.contains(value)) {
      _selectedChats.remove(value);
    } else {
      _selectedChats.add(value);
    }
    notifyListeners();
  }

  void clearSelectedChats() {
    _selectedChats.clear();
    notifyListeners();
  }

  // void archiveChats(List<Chat> value) {
  //   _archivedChats.addAll(value);
  //   notifyListeners();
  // }

  Future<bool> getAllUsers() async {
    final res = await chatService.getAllUsers();
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (users) {
      setUsers(users);
      return true;
    });
  }

  Future<bool> getChats() async {
    final res = await chatService.getChats();
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (chats) {
      setChats(chats);
      return true;
    });
  }

  Future<bool> deleteSelectedChats() async {
    _chats.removeWhere((chat) => _selectedChats.contains(chat));
    notifyListeners();
    final res = await chatService.deleteChats(
      _selectedChats.map((e) => e.id).toList(),
    );
    _selectedChats.clear();
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (_) {
      getChats();
      return true;
    });
  }

  Future<bool> deleteChat(Chat chat) async {
    _chats.remove(chat);
    notifyListeners();
    final res = await chatService.deleteChats(
      [chat.id],
    );
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (_) {
      getChats();
      return true;
    });
  }

  Future<bool> getMessages({
    required Chat chat,
  }) async {
    await chatService.createChat(chat);
    final res = await chatService.getMessages(chat.id);
    return res.fold((failure) {
      setErrorMessage(failure.message);
      return false;
    }, (messages) {
      setMessages(messages);
      return true;
    });
  }

  void listenForNewMessage({VoidCallback? callback}) {
    socketService.onEvent(
      RECEIVE_MESSAGE,
      (res) {
        log('got new message: $res');
        if (_messages.isEmpty) getChats();
        final newMessage = ChatMessage.fromMap(res);
        if (!_messages.contains(newMessage)) {
          _messages.add(newMessage);
          notifyListeners();
        }
        if (callback != null) callback();
        //* Update the last message in the relevant chat
        final chatIndex =
            _chats.indexWhere((chat) => chat.id == newMessage.chatId);
        if (chatIndex != -1) {
          _chats[chatIndex] =
              _chats[chatIndex].copyWith(lastMessage: newMessage);
          notifyListeners();
        }
      },
    );
  }

  void sendMessage(ChatMessage message) {
    socketService.emitEvent(
      SEND_MESSAGE,
      message.toMap(),
    );
  }

  void joinRoom(String chatId) {
    socketService.emitEvent(JOIN_CHAT, chatId);
  }
}
