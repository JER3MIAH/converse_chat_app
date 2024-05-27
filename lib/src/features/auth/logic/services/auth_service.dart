import 'package:converse/src/core/services/database_service.dart';
import 'package:converse/src/features/notifications/logic/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final DatabaseService databaseService;
  final NotificationService notificationService;

  AuthService({
    required this.databaseService,
    required this.notificationService,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(
      String username, String email, String password) async {
    try {
      final pushToken = await notificationService.getToken();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(username);

      await databaseService.addUserToDataBase(
        username,
        email,
        pushToken,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await databaseService.retrieveUserInfo(email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
