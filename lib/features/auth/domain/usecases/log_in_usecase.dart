import 'package:whispr/core/error/result.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LogInUsecase {
  final AuthRepository _repository;

  const LogInUsecase(this._repository);

  Future<Result<AuthResult>> call({
    required String identifier,
    required String password,
  }) {
    return _repository.logIn(identifier: identifier, password: password);
  }
}
