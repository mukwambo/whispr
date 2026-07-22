import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/auth/domain/entities/user.dart';
import 'package:whispr/features/auth/domain/repositories/auth_repository.dart';
import 'package:whispr/features/auth/domain/usecases/send_recovery_email_usecase.dart';
import 'package:whispr/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:whispr/features/auth/domain/usecases/skip_recovery_usecase.dart';
import 'package:whispr/features/auth/domain/usecases/watch_auth_state_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  test('SendRecoveryEmailUsecase delegates to the repository', () async {
    when(() => repository.sendRecoveryEmail(email: 'a@x.com'))
        .thenAnswer((_) async => const Right(unit));

    final result = await SendRecoveryEmailUsecase(repository).call(email: 'a@x.com');

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.sendRecoveryEmail(email: 'a@x.com')).called(1);
  });

  test('SkipRecoveryUsecase delegates to the repository', () async {
    when(() => repository.skipRecovery()).thenAnswer((_) async => const Right(unit));

    final result = await SkipRecoveryUsecase(repository).call();

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.skipRecovery()).called(1);
  });

  test('SignOutUsecase delegates to the repository', () async {
    when(() => repository.signOut()).thenAnswer((_) async => const Right(unit));

    final result = await SignOutUsecase(repository).call();

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.signOut()).called(1);
  });

  test('WatchAuthStateUsecase forwards the repository stream', () async {
    const user = User(id: 'u1', username: 'a');
    when(() => repository.watchAuthState()).thenAnswer((_) => Stream.value(user));

    final result = await WatchAuthStateUsecase(repository).call().first;

    expect(result, user);
    verify(() => repository.watchAuthState()).called(1);
  });
}
