# workspace_product

Layer 3 product for shared workspaces, membership, invitations, linked-wallet selection and workspace settings/reports.

## Responsibility and composition

The product owns workspace persistence, domain rules, state and UI. Wallet relationships are stored as IDs and exposed through neutral wallet summary/catalog contracts. `identity_service` provides identity capability. The product has no dependency on `wallet_product` or another Layer 3 product; the Layer 4 app adapts product APIs when workspace screens need wallet data or transaction/report experiences.

The host app registers product entry screens and owns all application route decisions. Workspace transitions are expressed through the `WorkspaceNavigation` callback contract supplied in `WorkspaceProductConfig`; this package does not declare host route paths or depend on `go_router`.

## Use

```yaml
dependencies:
  workspace_product:
    git:
      url: https://github.com/mahafez-app/workspace_product.git
      ref: v2.0.0
```

Import `package:workspace_product/workspace_product.dart` for supported screens, configuration, wallet catalog contracts and providers. Do not import implementation files under `src` from another repository.
