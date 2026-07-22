import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/auth/domain/entities/auth_result.dart';
import 'package:whispr/features/auth/domain/entities/user.dart';
import 'package:whispr/features/auth/domain/repositories/auth_repository.dart';
import 'package:whispr/features/auth/domain/usecases/sign_up_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late SignUpUsecase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignUpUsecase(repository);
  });

  test('delegates to AuthRepository.signUp with the same arguments', () async {
    const expected = Right<Failure, AuthResult>(
      AuthResult(user: User(id: 'u1', username: 'a', email: 'a@x.com'), isNewUser: true),
    );
    when(() => repository.signUp(
          username: 'a',
          email: 'a@x.com',
          password: 'password1',
        )).thenAnswer((_) async => expected);

    final result = await usecase(username: 'a', email: 'a@x.com', password: 'password1');

    expect(result, expected);
    verify(() => repository.signUp(username: 'a', email: 'a@x.com', password: 'password1')).called(1);
  });

  test('propagates a failure unchanged', () async {
    const expected = Left<Failure, AuthResult>(EmailAlreadyInUseFailure());
    when(() => repository.signUp(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => expected);

    final result = await usecase(username: 'a', email: 'a@x.com', password: 'password1');

    expect(result, expected);
  });
}
