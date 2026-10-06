import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../utils/amount_extension.dart';
import '../utils/localization_extension.dart';
import '../utils/wallet_provider_ext.dart';
import '../wallet_catalog.dart';

class ProviderIcon extends StatelessWidget {
  const ProviderIcon({super.key, required this.provider, required this.size});

  final WalletProvider provider;
  final double size;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: size / 2,
    backgroundColor: provider.brandColor.withAlpha(24),
    child: Icon(
      Icons.account_balance_wallet_rounded,
      color: provider.brandColor,
    ),
  );
}

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.provider,
    required this.phoneNumber,
    required this.balance,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final double balance;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProviderIcon(provider: provider, size: 44),
          const SizedBox(height: 12),
          Text(provider.displayName(context)),
          Text(phoneNumber),
          Text(balance.toCurrencyText(context)),
        ],
      ),
    ),
  );
}

class WalletTile extends StatelessWidget {
  const WalletTile({
    super.key,
    required this.wallet,
    this.ownerName,
    this.showOwnerName = false,
    this.onActionPressed,
    this.actionIcon,
    this.actionTooltip,
    this.isActionLoading = false,
  });

  final WorkspaceWalletSummary wallet;
  final String? ownerName;
  final bool showOwnerName;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final String? actionTooltip;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: ProviderIcon(provider: wallet.provider, size: 44),
      title: Text(wallet.provider.displayName(context)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(wallet.phoneNumber),
          Text(wallet.currentBalance.toCurrencyText(context)),
          if (showOwnerName && ownerName != null) Text(ownerName!),
        ],
      ),
      trailing: onActionPressed == null
          ? null
          : IconButton(
              onPressed: isActionLoading ? null : onActionPressed,
              icon: isActionLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(actionIcon ?? Icons.more_horiz),
              tooltip: actionTooltip,
            ),
    ),
  );
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.sentAmount,
    required this.receivedAmount,
    required this.label,
    this.subtitle,
    this.icon,
  });

  final double balance;
  final double sentAmount;
  final double receivedAmount;
  final String label;
  final Widget? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (icon != null) Icon(icon),
            ],
          ),
          Text(
            balance.toCurrencyText(context),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (subtitle != null) subtitle!,
          const SizedBox(height: 12),
          Text(
            '${context.l10n.totalOut}: ${sentAmount.toCurrencyText(context)}',
          ),
          Text(
            '${context.l10n.totalIn}: ${receivedAmount.toCurrencyText(context)}',
          ),
        ],
      ),
    ),
  );
}
