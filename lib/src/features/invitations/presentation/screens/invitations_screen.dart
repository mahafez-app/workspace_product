import 'package:flutter/material.dart';

import 'package:workspace_product/src/utils/localization_extension.dart';

import '../widgets/invitations/invitations_body.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.invitationsTitle)),
      body: const SafeArea(child: InvitationsBody()),
    );
  }
}
