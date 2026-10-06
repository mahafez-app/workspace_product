import 'package:mahafez_design_system/mahafez_design_system.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workspace_product/src/workspace_product_config_provider.dart';
import 'package:workspace_product/src/utils/failure_extension.dart';

import '../../providers/invitations_controller.dart';
import '../../providers/invitations_state.dart';
import 'invitations_content.dart';
import 'invitations_loading_content.dart';

class InvitationsBody extends ConsumerWidget {
  const InvitationsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<InvitationsState>>(
      invitationsControllerProvider,
      (previous, next) => _handleStateChange(context, ref, previous, next),
    );

    final state = ref.watch(invitationsControllerProvider);
    return switch (state) {
      AsyncLoading() => const InvitationsLoadingContent(),
      AsyncError(:final error) => MahafezErrorView(
        error: error,
        onRetry: () => ref.invalidate(invitationsControllerProvider),
      ),
      AsyncData(:final value) => InvitationsContent(state: value),
    };
  }

  void _handleStateChange(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<InvitationsState>? previous,
    AsyncValue<InvitationsState> next,
  ) {
    final feedback = next.asData?.value.feedback;
    if (feedback == null || previous?.asData?.value.feedback == feedback) {
      return;
    }

    if (!feedback.isSuccess) {
      MahafezSnackbar.show(
        context,
        message: feedback.failure!.toLocalizedString(context),
        type: MahafezSnackbarType.error,
      );
      return;
    }

    if (feedback.action == InvitationActionType.accept) {
      ref
          .read(workspaceProductConfigProvider)
          .navigation
          .openWorkspaceDetails(context, feedback.invitation.workspaceId);
    }
  }
}
