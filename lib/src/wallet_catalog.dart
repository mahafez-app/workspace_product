import 'package:mahafez_core/mahafez_core.dart';

/// Wallet metadata needed to present and manage workspace wallet links.
/// This contract keeps workspace_product independent from wallet_product.
final class WorkspaceWalletSummary {
  const WorkspaceWalletSummary({
    required this.id,
    required this.ownerUid,
    required this.provider,
    required this.phoneNumber,
    required this.currentBalance,
    required this.totalReceived,
    required this.totalSent,
    required this.lastActivityAt,
  });

  final String id;
  final String ownerUid;
  final WalletProvider provider;
  final String phoneNumber;
  final double currentBalance;
  final double totalReceived;
  final double totalSent;
  final DateTime lastActivityAt;
}

/// Adapter implemented by the app using its wallet_product public API.
abstract interface class WorkspaceWalletCatalog {
  Future<List<WorkspaceWalletSummary>> getOwnedWallets(String ownerUid);

  Future<List<WorkspaceWalletSummary>> getByIds(List<String> ids);

  Stream<List<WorkspaceWalletSummary>> watchByIds(List<String> ids);
}
