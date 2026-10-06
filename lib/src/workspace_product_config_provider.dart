import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace_product.dart';

final workspaceProductConfigProvider = Provider<WorkspaceProductConfig>(
  (ref) => throw StateError(
    'workspaceProductConfigProvider must be overridden by the app shell.',
  ),
);
