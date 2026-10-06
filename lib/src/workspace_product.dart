import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:identity_service/identity_service.dart';

import 'wallet_catalog.dart';

/// Runtime integrations supplied by the Layer 4 app shell.
final class WorkspaceProductConfig {
  const WorkspaceProductConfig({
    required this.firestore,
    required this.identityService,
    required this.currentUserId,
    required this.currentUser,
    required this.walletCatalog,
    required this.onOpenWallet,
    required this.onOpenTransactions,
    required this.buildWorkspaceReport,
  });

  final FirebaseFirestore firestore;
  final IdentityService identityService;
  final String? Function() currentUserId;
  final UserProfile? Function() currentUser;
  final WorkspaceWalletCatalog walletCatalog;
  final void Function(BuildContext context, String walletId) onOpenWallet;
  final void Function(
    BuildContext context,
    WorkspaceTransactionsContext transactions,
  )
  onOpenTransactions;
  final Widget Function(
    BuildContext context,
    String workspaceId,
    List<WorkspaceWalletSummary> wallets,
  )
  buildWorkspaceReport;
}

final class WorkspaceTransactionsContext {
  const WorkspaceTransactionsContext({
    required this.title,
    required this.wallets,
  });

  final String title;
  final List<WorkspaceTransactionWalletOption> wallets;
}

final class WorkspaceTransactionWalletOption {
  const WorkspaceTransactionWalletOption({
    required this.walletId,
    required this.walletLabel,
    required this.memberId,
    required this.memberName,
  });

  final String walletId;
  final String walletLabel;
  final String memberId;
  final String memberName;
}
