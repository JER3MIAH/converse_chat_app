import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      sl<AuthService>().saveFcmToken();
      return null;
    }, const []);
    return const Scaffold(
      body: Center(
        child: Text('home screen'),
      ),
    );
  }
}
