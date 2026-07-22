import 'package:whispr/core/error/result.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository _repository;

  const SignUpUsecase(this._repository);

  Future<Result<AuthResult>> call({
    required String username,
    required String email,
    required String password,
  }) {
    return _repository.signUp(username: username, email: email, password: password);
  }
}
