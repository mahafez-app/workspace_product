# workspace_product

Layer 3 workspace and invitation product for the Mahafez platform. It owns workspace membership, wallet links by ID, invitations, settings, and product UI.

The package depends on the headless `identity_service` capability to resolve user profiles. It does not depend on `identity_product` or `wallet_product`. The Layer 4 app supplies Firestore, identity, and a `WorkspaceWalletCatalog` adapter. That adapter exposes only neutral wallet summaries and keeps wallet persistence and domain types inside `wallet_product`.

The app also supplies callbacks for wallet details, transaction history, and workspace reports, so this product does not own app routing or depend on a peer product.

## Integration

Override `workspaceProductConfigProvider` and `workspaceCurrentUserProvider` in the app's `ProviderScope`, register the exported screens with `WorkspaceRoutes`, and add `WorkspaceLocalizations.localizationsDelegates` to the host app.
