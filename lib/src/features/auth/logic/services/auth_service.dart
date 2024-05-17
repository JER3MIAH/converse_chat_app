import 'package:converse/src/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final DatabaseService databaseService;

  AuthService({
    required this.databaseService,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(
      String username, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(username);

      await databaseService.addUserToDataBase(username, email);
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
