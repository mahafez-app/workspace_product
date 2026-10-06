// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_product/src/current_user_provider.dart';
import 'package:workspace_product/src/workspace_product_config_provider.dart';

import '../../../invitations/presentation/widgets/invitations/invite_member_bottom_sheet.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../providers/workspace_details_controller.dart';
import '../widgets/details/workspace_members_section.dart';
import '../widgets/details/workspace_summary_card.dart';
import '../widgets/details/workspace_transactions_section.dart';
import '../widgets/details/workspace_wallets_section.dart';
import 'workspace_unavailable_guard.dart';

class WorkspaceDetailsScreen extends StatelessWidget {
  const WorkspaceDetailsScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _WorkspaceDetailsTitle(workspaceId: workspaceId),
        actions: [_WorkspaceDetailsActions(workspaceId: workspaceId)],
      ),
      body: SafeArea(child: _WorkspaceDetailsBody(workspaceId: workspaceId)),
    );
  }
}

class _WorkspaceDetailsActions extends ConsumerWidget {
  const _WorkspaceDetailsActions({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(workspaceCurrentUserProvider)?.uid;
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        IconButton(
          onPressed: () => ref
              .read(workspaceProductConfigProvider)
              .navigation
              .openWorkspaceReport(context, workspaceId),
          icon: const Icon(Icons.bar_chart_rounded),
        ),
        IconButton(
          onPressed: () => ref
              .read(workspaceProductConfigProvider)
              .navigation
              .openWorkspaceSettings(context, workspaceId),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}

class _WorkspaceDetailsTitle extends ConsumerWidget {
  const _WorkspaceDetailsTitle({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceDetailsControllerProvider(workspaceId));
    final title = state.asData?.value.workspace.name ?? '';

    return Text(title);
  }
}

class _WorkspaceDetailsBody extends ConsumerWidget {
  const _WorkspaceDetailsBody({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceDetailsControllerProvider(workspaceId));
    final currentUserId = ref.watch(workspaceCurrentUserProvider)?.uid;
    return WorkspaceUnavailableGuard<WorkspaceDetailsEntity>(
      state: state,
      currentUserId: currentUserId,
      detailsSelector: (details) => details,
      onExit: () =>
          ref.read(workspaceProductConfigProvider).navigation.close(context),
      dataBuilder: (_, details) => _WorkspaceDetailsDataView(details: details),
    );
  }
}

class _WorkspaceDetailsDataView extends ConsumerWidget {
  const _WorkspaceDetailsDataView({super.key, required this.details});

  final WorkspaceDetailsEntity details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(workspaceCurrentUserProvider);
    final canInviteMembers = currentUser?.uid == details.workspace.ownerUid;

    return SingleChildScrollView(
      padding: MahafezSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkspaceSummaryCard(details: details),
          MahafezSpacing.lg.verticalSpace,
          WorkspaceWalletsSection(
            wallets: details.wallets,
            onAddWallets: () => ref
                .read(workspaceProductConfigProvider)
                .navigation
                .openWalletSelection(context, details.workspace.id),
          ),
          MahafezSpacing.xxl.verticalSpace,
          WorkspaceTransactionsSection(details: details),
          MahafezSpacing.xxl.verticalSpace,
          WorkspaceMembersSection(
            members: details.members,
            onInviteMember: canInviteMembers
                ? () => InviteMemberBottomSheet.show(
                    context,
                    workspaceId: details.workspace.id,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
