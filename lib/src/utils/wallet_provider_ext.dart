import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import 'localization_extension.dart';

extension WorkspaceWalletProviderDisplay on WalletProvider {
  String displayName(BuildContext context) => switch (this) {
    WalletProvider.vodafoneCash => context.l10n.providerVodafone,
    WalletProvider.orangeMoney => context.l10n.providerOrange,
    WalletProvider.etisalatCash => context.l10n.providerEtisalat,
    WalletProvider.instaPay => context.l10n.providerInstapay,
    WalletProvider.wePay => context.l10n.providerWePay,
    WalletProvider.unknown => context.l10n.providerUnknown,
  };

  Color get brandColor => switch (this) {
    WalletProvider.vodafoneCash => MahafezColors.vodafoneRed,
    WalletProvider.orangeMoney => MahafezColors.orangeMoney,
    WalletProvider.etisalatCash => MahafezColors.etisalatGreen,
    WalletProvider.instaPay => MahafezColors.instaPayNavy,
    WalletProvider.wePay => MahafezColors.wePayPurple,
    WalletProvider.unknown => MahafezColors.providerUnknownNeutral,
  };
}
