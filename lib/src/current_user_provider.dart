import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:identity_service/identity_service.dart';

final workspaceCurrentUserProvider = Provider<UserProfile?>((ref) {
  throw StateError(
    'workspaceCurrentUserProvider must be overridden by the app shell.',
  );
});
