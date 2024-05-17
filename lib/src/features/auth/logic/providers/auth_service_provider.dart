import 'package:converse/src/core/providers/database_service_provider.dart';
import 'package:converse/src/features/auth/logic/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    databaseService: ref.read(databaseServiceProvider),
  ),
);
