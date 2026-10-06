import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import 'package:workspace_product/src/workspace_product_config_provider.dart';

import '../../providers/workspace_wallet_selection_controller.dart';
import '../../providers/workspace_wallet_selection_state.dart';
import 'workspace_wallet_selection_content.dart';

class SelectWorkspaceWalletsBody extends ConsumerWidget {
  const SelectWorkspaceWalletsBody({
    super.key,
    required this.workspaceId,
    required this.isCreateFlow,
  });

  final String workspaceId;
  final bool isCreateFlow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = workspaceWalletSelectionControllerProvider(workspaceId);
    final controller = ref.read(provider.notifier);

    ref.listen<AsyncValue<WorkspaceWalletSelectionState>>(
      provider,
      (previous, next) => _handleStateChange(
        context,
        ref,
        previous?.asData?.value,
        next.asData?.value,
      ),
    );

    final stateAsync = ref.watch(provider);

    return switch (stateAsync) {
      AsyncLoading() => const MahafezLoader(),
      AsyncError(:final error) => MahafezErrorView(
        error: error,
        onRetry: () => ref.invalidate(provider),
      ),
      AsyncData(:final value) => WorkspaceWalletSelectionContent(
        state: value,
        isCreateFlow: isCreateFlow,
        onToggleWallet: controller.toggleWallet,
        onSubmit: controller.submit,
        onSkipWallets: () => ref
            .read(workspaceProductConfigProvider)
            .navigation
            .skipWalletSelection(context, workspaceId),
      ),
    };
  }

  void _handleStateChange(
    BuildContext context,
    WidgetRef ref,
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState? next,
  ) {
    if (next == null) return;

    if (_hasNewFailure(previous, next)) {
      _showFailureSnackbar(context, next.submissionFailure!);
      return;
    }

    if (!_hasSuccessfulSubmission(previous, next)) return;

    if (isCreateFlow) {
      ref
          .read(workspaceProductConfigProvider)
          .navigation
          .completeWalletSelection(
            context,
            workspaceId: workspaceId,
            linkedCount: next.linkedCount,
            fromCreation: true,
          );
      return;
    }
    ref
        .read(workspaceProductConfigProvider)
        .navigation
        .completeWalletSelection(
          context,
          workspaceId: workspaceId,
          linkedCount: next.linkedCount,
          fromCreation: false,
        );
  }

  bool _hasNewFailure(
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState next,
  ) {
    return next.submissionStatus ==
            WorkspaceWalletSelectionSubmissionStatus.failure &&
        previous?.submissionFailure != next.submissionFailure &&
        next.submissionFailure != null;
  }

  bool _hasSuccessfulSubmission(
    WorkspaceWalletSelectionState? previous,
    WorkspaceWalletSelectionState next,
  ) {
    return previous?.submissionStatus !=
            WorkspaceWalletSelectionSubmissionStatus.success &&
        next.submissionStatus ==
            WorkspaceWalletSelectionSubmissionStatus.success;
  }

  void _showFailureSnackbar(BuildContext context, Failure failure) {
    MahafezSnackbar.showFailure(context, failure: failure);
  }
}
