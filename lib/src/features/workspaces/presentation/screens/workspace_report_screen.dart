import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:workspace_product/src/workspace_product_config_provider.dart';


import '../providers/workspace_details_controller.dart';

/// Composes workspace-owned wallet metadata into the wallet product's report UI.
class WorkspaceReportScreen extends ConsumerWidget {
  const WorkspaceReportScreen({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(
      workspaceDetailsControllerProvider(workspaceId),
    );
    return switch (workspace) {
      AsyncLoading() => const Scaffold(body: Center(child: MahafezLoader())),
      AsyncError(:final error) => Scaffold(
        body: Padding(
          padding: MahafezSpacing.pagePadding,
          child: Center(child: MahafezErrorView(error: error)),
        ),
      ),
      AsyncData(:final value) =>
        ref
            .watch(workspaceProductConfigProvider)
            .buildWorkspaceReport(context, workspaceId, value.wallets),
    };
  }
}
