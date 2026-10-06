import 'package:flutter/widgets.dart';

import '../generated/workspace_localizations.dart';

extension LocalizationExtension on BuildContext {
  WorkspaceLocalizations get l10n => WorkspaceLocalizations.of(this)!;
}
