import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/result.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _repository;

  const SignOutUsecase(this._repository);

  Future<Result<Unit>> call() {
    return _repository.signOut();
  }
}
