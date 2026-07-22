import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUsecase {
  final AuthRepository _repository;

  const WatchAuthStateUsecase(this._repository);

  Stream<User?> call() => _repository.watchAuthState();
}
