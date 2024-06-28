import 'dart:developer';

import 'package:converse/firebase_options.dart';
import 'package:converse/src/app.dart';
import 'package:converse/src/features/notifications/data/repositories/local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a backdroun message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotifications.init();
  if (!FirebaseMessaging.instance.isAutoInitEnabled) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  await FirebaseMessaging.instance.getInitialMessage();
  Future.delayed(
    const Duration(milliseconds: 500),
    () => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}
