const baseUrl = 'http://192.168.36.142:5050'; //TODO:
const apiVersion = 'api';

final authEndpoints = _AuthEndpoints();
final chatEndpoints = _ChatEndpoints();

class _AuthEndpoints {
  final login = '$baseUrl/$apiVersion/user/login';
  final signup = '$baseUrl/$apiVersion/user/signup';
  final saveFcmToken = '$baseUrl/$apiVersion/user/save-fcm-token';
  // final resetPassword = '$baseUrl/$apiVersion/user/reset-password';
  // final saveFcmToken = '$baseUrl/$apiVersion/user/save-fcm-token';
}

class _ChatEndpoints {
  final getChats = '$baseUrl/$apiVersion/chat';
}
