import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_product/src/workspace_product_config_provider.dart';

import '../data/datasources/invitations_remote_data_source.dart';
import '../data/repositories/invitations_repository_impl.dart';
import '../domain/repositories/invitations_repository.dart';
import '../domain/usecases/accept_invitation_usecase.dart';
import '../domain/usecases/cancel_invitation_usecase.dart';
import '../domain/usecases/create_invitation_usecase.dart';
import '../domain/usecases/decline_invitation_usecase.dart';
import '../domain/usecases/get_pending_invitations_usecase.dart';
import '../domain/usecases/get_recent_responded_invitations_usecase.dart';
import '../domain/usecases/get_workspace_pending_invitations_usecase.dart';
import '../domain/usecases/watch_workspace_pending_invitations_usecase.dart';

final invitationsRemoteDataSourceProvider =
    Provider<InvitationsRemoteDataSource>(
      (ref) => InvitationsRemoteDataSourceImpl(
        firestore: ref.watch(workspaceProductConfigProvider).firestore,
        currentUserId: ref.watch(workspaceProductConfigProvider).currentUserId,
        identityService: ref
            .watch(workspaceProductConfigProvider)
            .identityService,
      ),
    );

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => InvitationsRepositoryImpl(
    remote: ref.watch(invitationsRemoteDataSourceProvider),
  ),
);

final pendingInvitationsCountStreamProvider = Provider<Stream<int>>(
  (ref) => ref
      .watch(invitationsRemoteDataSourceProvider)
      .watchPendingInvitationsCount(),
);

final createInvitationUseCaseProvider = Provider<CreateInvitationUseCase>(
  (ref) => CreateInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

final getPendingInvitationsUseCaseProvider =
    Provider<GetPendingInvitationsUseCase>(
      (ref) => GetPendingInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final getWorkspacePendingInvitationsUseCaseProvider =
    Provider<GetWorkspacePendingInvitationsUseCase>(
      (ref) => GetWorkspacePendingInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final watchWorkspacePendingInvitationsUseCaseProvider =
    Provider<WatchWorkspacePendingInvitationsUseCase>(
      (ref) => WatchWorkspacePendingInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final getRecentRespondedInvitationsUseCaseProvider =
    Provider<GetRecentRespondedInvitationsUseCase>(
      (ref) => GetRecentRespondedInvitationsUseCase(
        ref.watch(invitationsRepositoryProvider),
      ),
    );

final acceptInvitationUseCaseProvider = Provider<AcceptInvitationUseCase>(
  (ref) => AcceptInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

final declineInvitationUseCaseProvider = Provider<DeclineInvitationUseCase>(
  (ref) => DeclineInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);

final cancelInvitationUseCaseProvider = Provider<CancelInvitationUseCase>(
  (ref) => CancelInvitationUseCase(ref.watch(invitationsRepositoryProvider)),
);
