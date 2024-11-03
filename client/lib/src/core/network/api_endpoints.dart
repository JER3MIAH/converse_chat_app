const YOUR_IP_ADDRESS = '';

const baseUrl = 'http://$YOUR_IP_ADDRESS:5050'; //TODO:
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
  final createChat = '$baseUrl/$apiVersion/chat/create-chat';
  final createMessage = '$baseUrl/$apiVersion/chat/get-chats';
  final getMessages = '$baseUrl/$apiVersion/chat/get-messages';
}
