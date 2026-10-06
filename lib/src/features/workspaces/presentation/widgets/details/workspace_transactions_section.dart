// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_product/src/workspace_product_config_provider.dart';
import 'package:workspace_product/src/workspace_product.dart';

import 'package:workspace_product/src/utils/localization_extension.dart';
import 'package:workspace_product/src/utils/phone_number_extension.dart';
import 'package:workspace_product/src/utils/wallet_provider_ext.dart';
import 'package:workspace_product/src/utils/date_extensions.dart';

import '../../../domain/entities/workspace_details_entity.dart';

class WorkspaceTransactionsSection extends ConsumerWidget {
  const WorkspaceTransactionsSection({super.key, required this.details});

  final WorkspaceDetailsEntity details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hasWallets = details.wallets.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.transactionsHistory,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasWallets)
              TextButton(
                onPressed: () => _openWorkspaceTransactions(context, ref),
                child: Text(l10n.viewAll),
              ),
          ],
        ),
        MahafezSpacing.md.verticalSpace,
        if (!hasWallets)
          _WorkspaceNoTransactionsCard(
            title: l10n.transactions_emptyTitle,
            description: l10n.transactions_emptyWorkspaceDescription,
          )
        else
          _WorkspaceTransactionsActivityCard(
            details: details,
            onViewAll: () => _openWorkspaceTransactions(context, ref),
          ),
      ],
    );
  }

  void _openWorkspaceTransactions(BuildContext context, WidgetRef ref) {
    final memberNamesByUid = {
      for (final member in details.members) member.uid: member.displayName,
    };
    ref
        .read(workspaceProductConfigProvider)
        .onOpenTransactions(
          context,
          WorkspaceTransactionsContext(
            title: details.workspace.name,
            wallets: details.wallets
                .map(
                  (wallet) => WorkspaceTransactionWalletOption(
                    walletId: wallet.id,
                    walletLabel:
                        '${wallet.provider.displayName(context)} · ${wallet.phoneNumber.formattedEgyptianPhoneNumber}',
                    memberId: wallet.ownerUid,
                    memberName:
                        memberNamesByUid[wallet.ownerUid] ??
                        context.l10n.workspaceUnknownMember,
                  ),
                )
                .toList(),
          ),
        );
  }
}

class _WorkspaceNoTransactionsCard extends StatelessWidget {
  const _WorkspaceNoTransactionsCard({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined),
          const SizedBox(height: 8),
          Text(title),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _WorkspaceTransactionsActivityCard extends StatelessWidget {
  const _WorkspaceTransactionsActivityCard({
    super.key,
    required this.details,
    required this.onViewAll,
  });

  final WorkspaceDetailsEntity details;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final latestActivity = details.latestActivityAt;
    final description = latestActivity == null
        ? l10n.workspaceTransactionsCtaDescription
        : l10n.workspaceTransactionsCtaDescriptionWithActivity;
    final latestActivityLabel = latestActivity == null
        ? l10n.lastActivity
        : '${l10n.lastActivity}: ${latestActivity.toTimeAgo(context)}';

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(
          MahafezSpacing.xxl.responsiveRadius,
        ),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: MahafezSpacing.lg.responsiveRadius,
            offset: Offset(0, MahafezSpacing.xs.responsiveHeight),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: MahafezResponsive.allPadding(MahafezSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(
                    MahafezSpacing.lg.responsiveRadius,
                  ),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.colorScheme.primary,
                  size: MahafezSpacing.xl.responsiveRadius,
                ),
              ),
              MahafezSpacing.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.transactionsHistory,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    MahafezSpacing.xs.verticalSpace,
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MahafezSpacing.lg.verticalSpace,
          Wrap(
            spacing: MahafezSpacing.sm.responsiveWidth,
            runSpacing: MahafezSpacing.sm.responsiveHeight,
            children: [
              _WorkspaceActivityChip(
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.workspaceWalletsCount(details.wallets.length),
              ),
              _WorkspaceActivityChip(
                icon: Icons.schedule_rounded,
                label: latestActivityLabel,
              ),
            ],
          ),
          MahafezSpacing.lg.verticalSpace,
          MahafezButton(
            label: l10n.viewAllTransactions,
            type: MahafezButtonType.secondary,
            onPressed: onViewAll,
            trailingIcon: Icon(
              Icons.arrow_forward_rounded,
              size: MahafezSpacing.lg.responsiveRadius,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceActivityChip extends StatelessWidget {
  const _WorkspaceActivityChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.md,
        vertical: MahafezSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.infoContainer,
        borderRadius: BorderRadius.circular(999.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: MahafezSpacing.md.responsiveRadius,
            color: theme.colorScheme.primary,
          ),
          MahafezSpacing.xs.horizontalSpace,
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
