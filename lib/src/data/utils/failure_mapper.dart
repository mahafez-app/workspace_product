import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahafez_core/mahafez_core.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(Object error) => switch (error) {
    Failure failure => failure,
    FirebaseException exception when exception.code == 'unavailable' =>
      CacheFailure(technicalMessage: exception.message),
    FirebaseException exception when exception.code == 'permission-denied' =>
      PermissionFailure(
        code: exception.code,
        technicalMessage: exception.message,
      ),
    FirebaseException exception => ServerFailure(
      code: exception.code,
      technicalMessage: exception.message,
    ),
    SocketException exception => NetworkFailure(
      technicalMessage: exception.message,
    ),
    _ => UnknownFailure(technicalMessage: error.toString()),
  };
}
