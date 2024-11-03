import 'dart:developer';
import 'package:converse/src/core/core.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final ApiClient client;

  SocketService({
    required this.client,
  });

  late IO.Socket _socket;

  void initializeSocket() {
    final bearerToken = client.getToken();
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'Bearer $bearerToken',
      },
    });

    _socket.connect();

    _socket.onConnectError((error) {
      log('Connection error: $error');
    });

    _socket.onConnect((_) {
      log('Connected to WebSocket server $baseUrl');
      _listenForPing();
    });

    _socket.onReconnectAttempt((attemptNumber) {
      log('Attempting to reconnect to WebSocket server: $attemptNumber');
    });

    _socket.onReconnectError((error) {
      log('Reconnection error: $error');
    });

    _socket.onReconnectFailed((_) {
      log('Reconnection failed');
    });

    _socket.onReconnect((attemptNumber) {
      log('Reconnected to WebSocket server on attempt $attemptNumber');
    });

    _socket.onDisconnect((_) {
      log('Disconnected from WebSocket server');
    });
  }

  void _listenForPing() {
    onEvent('PING', (data) {
      log('Received ping from server with data: $data');
    });
  }

  void onEvent(String event, Function(dynamic) callback) {
    log("Listening for $event event...");
    _socket.on(event, (data) {
      try {
        callback(data);
      } catch (e, stack) {
        log('Error handling event $event: $e\n$stack');
      }
    });
  }

  void emitEvent(String event, dynamic data) {
    log('emitted $event with data: $data');
    _socket.emit(event, data);
  }

  void offEvent(String event) {
    _socket.off(event);
    log('Stopped listening for event: $event');
  }

  void dispose() {
    _socket.clearListeners();
    _socket.disconnect();
    _socket.close();
    log('Socket connection closed and all listeners removed');
  }
}
