import 'dart:developer';

import 'package:converse/src/features/notifications/data/repositories/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  void initInfo() async {
    FirebaseMessaging.onMessage.listen((message) async {
      log('----------------------onMessage----------------------');
      log(
          'onMessgae: ${message.notification?.title}/${message.notification?.body}');

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
        // saveToken(token);
      },
    );
    return mToken;
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
