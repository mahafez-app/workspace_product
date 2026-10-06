abstract final class WorkspaceRoutes {
  static const home = '/home';
  static const create = '/add-workspace';
  static const details = '/workspace/:workspaceId';
  static const walletSelection = '/workspace/:workspaceId/wallets';
  static const settings = '/workspace/:workspaceId/settings';
  static const reports = '/workspace/:workspaceId/reports';
  static const invitations = '/invitations';

  static String workspaceDetailsPath(String workspaceId) =>
      '/workspace/$workspaceId';

  static String workspaceWalletSelectionPath(
    String workspaceId, {
    bool fromCreation = false,
  }) => fromCreation
      ? '/workspace/$workspaceId/wallets?flow=create'
      : '/workspace/$workspaceId/wallets';

  static String workspaceSettingsPath(String workspaceId) =>
      '/workspace/$workspaceId/settings';

  static String workspaceReportsPath(String workspaceId) =>
      '/workspace/$workspaceId/reports';

  static String workspaceInvitationsPath() => invitations;
}
