import 'dart:developer';
import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/features/chat/data/models/message.dart';
import 'package:converse/src/features/chat/logic/providers/chat_service_provider.dart';
import 'package:converse/src/features/chat/logic/services/chat_service.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider(chatService: ref.watch(chatServiceProvider));
});

class ChatProvider extends ChangeNotifier {
  final ChatService chatService;
  ChatProvider({
    required this.chatService,
  });

  void sendMessage(
      {required UserModel receiver, required String message}) async {
    try {
      if (message.isNotEmpty) {
        await chatService.sendMessage(receiver, message, 'TEXT');
      }
    } catch (e) {
      log('Failed to send message:  stack:$e');
    }
  }

  void sendImage({required UserModel receiver}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        // imageQuality: 65,
      );
      if (pickedImage != null) {
        await chatService.sendMessage(receiver, pickedImage.path, kImageType);
      }
    } catch (e) {
      log('Failed to send image:  stack:$e');
    }
  }

  Future<bool> saveImage(String imageUrl) async {
    try {
      await chatService.saveImageToGallery(imageUrl);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<ChatMessage>> getMessages({required UserModel receiver}) {
    return chatService.getMessages(receiver);
  }

  Future<bool> checkChatExists(String chatRoomID) async {
    return await chatService.checkChatExists(chatRoomID);
  }

  Future<void> createNewChat(String id1, String id2) async {
    await chatService.createNewChat(id1, id2);
  }

  void update() => notifyListeners();
}
