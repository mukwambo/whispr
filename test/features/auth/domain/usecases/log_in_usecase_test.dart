import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/auth/domain/entities/auth_result.dart';
import 'package:whispr/features/auth/domain/entities/user.dart';
import 'package:whispr/features/auth/domain/repositories/auth_repository.dart';
import 'package:whispr/features/auth/domain/usecases/log_in_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LogInUsecase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LogInUsecase(repository);
  });

  test('delegates to AuthRepository.logIn with the same arguments', () async {
    const expected = Right<Failure, AuthResult>(
      AuthResult(user: User(id: 'u1', username: 'a'), isNewUser: false),
    );
    when(() => repository.logIn(identifier: 'a', password: 'password1'))
        .thenAnswer((_) async => expected);

    final result = await usecase(identifier: 'a', password: 'password1');

    expect(result, expected);
    verify(() => repository.logIn(identifier: 'a', password: 'password1')).called(1);
  });

  test('propagates InvalidCredentialsFailure unchanged', () async {
    const expected = Left<Failure, AuthResult>(InvalidCredentialsFailure());
    when(() => repository.logIn(
          identifier: any(named: 'identifier'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => expected);

    final result = await usecase(identifier: 'a', password: 'wrong');

    expect(result, expected);
  });
}
