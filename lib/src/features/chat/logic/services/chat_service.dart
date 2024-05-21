import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/src/features/home/data/models/user_chat.dart';
import 'package:converse/src/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:converse/src/core/data/models/user_model.dart';
import 'package:converse/src/features/chat/data/models/message.dart';
import 'package:converse/src/features/home/logic/providers/user_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ChatService {
  final UserProvider userProvider;
  ChatService({
    required this.userProvider,
  });
  final _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  final _chatsColection = FirebaseFirestore.instance.collection('chat_rooms');

  Stream<List<UserModel>> getUsersStream() {
    return _db.collection('users').snapshots().map((snap) {
      return snap.docs.map((doc) {
        final user = doc.data();
        return UserModel(
          id: user['id'],
          username: user['username'],
          email: user['email'],
        );
      }).toList();
    });
  }

  Stream<List<UserModel>> getChattedUsersStream() {
    return _db.collection('users').snapshots().asyncMap((snap) async {
      final users = <UserModel>[];

      for (final doc in snap.docs) {
        final user = doc.data();
        final userModel = UserModel(
          id: user['id'],
          username: user['username'],
          email: user['email'],
        );

        final chatRoomID =
            generateChatId(id1: userProvider.user.id, id2: userModel.id);

        final chatExists = await checkChatExists(chatRoomID);
        if (chatExists) {
          users.add(userModel);
        }
      }

      return users;
    });
  }

  Stream<ChatMessage?> latestMessageStream(String chatRoomID) {
    return _chatsColection.doc(chatRoomID).snapshots().map((snapshot) {
      final chatData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> messagesData = chatData['messages'] ?? [];
      if (messagesData.isEmpty) return null;

      final latestMessageData = messagesData.last;
      final latestMessage = ChatMessage.fromMap(latestMessageData);
      return latestMessage;
    }).handleError((error) => log('Error fetching latest message: $error'));
  }

  Future<void> sendMessage(
    UserModel receiver,
    String message,
    String messageType,
  ) async {
    String chatRoomID = generateChatId(
      id1: userProvider.user.id,
      id2: receiver.id,
    );
    String? imageUrl;

    if (messageType == kImageType) {
      imageUrl = await _uploadImage(File(message));
    }
    ChatMessage newMessage = ChatMessage(
      sender: userProvider.user,
      receiver: receiver,
      message: messageType == kImageType ? imageUrl! : message,
      messageType: messageType,
      timeStamp: Timestamp.now(),
    );
    final docRef = _chatsColection.doc(chatRoomID);

    //? Add new message to database
    await docRef.update({
      'messages': FieldValue.arrayUnion(
        [
          newMessage.toMap(),
        ],
      ),
    });
  }

  Future<void> createNewChat(String id1, String id2) async {
    String chatRoomID = generateChatId(
      id1: id1,
      id2: id2,
    );
    final docRef = _chatsColection.doc(chatRoomID);
    final chat = UserChat(
      id: chatRoomID,
      participants: [id1, id2],
      messages: [],
    );
    await docRef.set(chat.toMap());
  }

  Future<bool> checkChatExists(String chatRoomID) async {
    final result = await _chatsColection.doc(chatRoomID).get();
    return result.exists;
  }

  Stream<List<ChatMessage>> getMessages(UserModel receiver) {
    String chatRoomID = generateChatId(
      id1: userProvider.user.id,
      id2: receiver.id,
    );

    return _chatsColection.doc(chatRoomID).snapshots().map((snapshot) {
      final chatData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> messagesData = chatData['messages'] ?? [];
      final List<ChatMessage> messages =
          messagesData.map((data) => ChatMessage.fromMap(data)).toList();
      return messages;
    });
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final ref = _firebaseStorage
          .ref()
          .child('chat_images')
          .child(DateTime.now().toString());
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    try {
      var response = await Dio()
          .get(imageUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
      );
      log('saved image: $result');
    } catch (e) {
      throw 'Error saving image to gallery: $e';
    }
  }
}
