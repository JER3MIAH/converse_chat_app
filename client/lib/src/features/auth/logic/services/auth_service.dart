import 'dart:developer';
// import 'package:converse/src/app_injection_container.dart';
import 'package:converse/src/core/core.dart';
import 'package:converse/src/features/auth/data/auth_response.dart';
import 'package:converse/src/features/auth/data/login_request.dart';
import 'package:converse/src/features/auth/data/signup_request.dart';
import 'package:converse/src/features/auth/data/user.dart';
import 'package:converse/src/features/auth/logic/token_repository.dart';
// import 'package:converse/src/features/notifications/logic/services/notification_service.dart';
import 'package:dartz/dartz.dart';

abstract class AuthService {
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);
  Future<Either<Failure, AuthResponse>> signup(SignUpRequest request);
  // Future<Either<Failure, void>> saveFcmToken();
}

class AuthServiceImpl extends AuthService {
  final ApiClient client;
  final TokenRepository tokenRepository;
  AuthServiceImpl({
    required this.client,
    required this.tokenRepository,
  });

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await client.post(
        authEndpoints.login,
        data: request.toMap(),
      );
      log('Login response: $response');
      final responseModel = AuthResponse.fromMap(response.data);
      final success = await tokenRepository.saveToken(
          responseModel.token,
          User(
            username: responseModel.username,
            email: responseModel.email,
            avatar: responseModel.avatar,
            id: responseModel.id,
          ));
      if (!success) {
        return left(GenericFailure(message: 'failed to save token'));
      }

      return right(responseModel);
    } catch (err, stack) {
      log('Login error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signup(SignUpRequest request) async {
    try {
      final response = await client.post(
        authEndpoints.signup,
        data: request.toMap(),
      );
      log('Sign up response: $response');
      final responseModel = AuthResponse.fromMap(response.data);
      final success = await tokenRepository.saveToken(
          responseModel.token,
          User(
            username: responseModel.username,
            email: responseModel.email,
            id: responseModel.id,
          ));
      if (!success) {
        return left(GenericFailure(message: 'failed to save token'));
      }

      return right(responseModel);
    } catch (err, stack) {
      log('Sign up error: $err\n$stack');
      return left(ApiFailure(message: err.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> saveFcmToken() async {
  //   try {
  //     final fcmToken = await sl<NotificationService>().getToken();
  //     await client.patch(authEndpoints.saveFcmToken, data: {'token': fcmToken});
  //     return right(null);
  //   } catch (err, stack) {
  //     log('Save fcm token error: $err\n$stack');
  //     return left(ApiFailure(message: err.toString()));
  //   }
  // }
}
