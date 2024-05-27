import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:converse/src/features/notifications/data/repositories/local_notifications.dart';
import 'package:converse/src/features/notifications/data/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  void initInfo() async {
    FirebaseMessaging.onMessage.listen((message) async {
      log('----------------------onMessage----------------------');
      log('onMessgae: ${message.notification?.title}/${message.notification?.body}');

      await LocalNotifications.showSimpleNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['title'] ?? '',
        message: message,
      );
    });
  }

  Future<String> getToken() async {
    String mToken = '';
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        mToken = token!;
        log('My token is $token');
      },
    );
    return mToken;
  }

  void sendPushNotification(String token, String title, String bodyy) async {
    final body = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": bodyy,
        },
      }
    };
    try {
      final res = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/star-e0a66/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log(e.toString());
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted providional permission');
    } else {
      log('User declined or did not accept permission');
    }
  }
}
