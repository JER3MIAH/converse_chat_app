import 'package:converse/src/core/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseServiceProvider =
    Provider<DatabaseService>((ref) => DatabaseService());
