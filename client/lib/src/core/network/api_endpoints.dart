const YOUR_IP_ADDRESS = '192.168.8.101';

const baseUrl = 'http://$YOUR_IP_ADDRESS:5050';
const apiVersion = 'api';

final authEndpoints = _AuthEndpoints();
final chatEndpoints = _ChatEndpoints();

class _AuthEndpoints {
  final login = '$baseUrl/$apiVersion/user/login';
  final signup = '$baseUrl/$apiVersion/user/signup';
  final saveFcmToken = '$baseUrl/$apiVersion/user/save-fcm-token';
}

class _ChatEndpoints {
  final getUsers = '$baseUrl/$apiVersion/user/get-all-users';
  final getChats = '$baseUrl/$apiVersion/chat/get-chats';
  final archiveChats = '$baseUrl/$apiVersion/chat/archive-chats';
  final deleteChats = '$baseUrl/$apiVersion/chat/delete-chats';
  final deleteMessages = '$baseUrl/$apiVersion/chat/delete-messages';
  final createChat = '$baseUrl/$apiVersion/chat/create-chat';
  final createMessage = '$baseUrl/$apiVersion/chat/get-chats';
  final getMessages = '$baseUrl/$apiVersion/chat/get-messages';
}
