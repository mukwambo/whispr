import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/auth/data/repositories/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() {
    repository = FakeAuthRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  group('signUp', () {
    test('succeeds and emits the new user on the auth-state stream', () async {
      final states = <dynamic>[];
      final subscription = repository.watchAuthState().listen(states.add);

      final result = await repository.signUp(
        username: 'wanderer',
        email: 'wanderer@example.com',
        password: 'supersecret',
      );

      expect(result.isRight(), isTrue);
      final authResult = result.getOrElse((_) => throw StateError('expected Right'));
      expect(authResult.isNewUser, isTrue);
      expect(authResult.user.username, 'wanderer');
      expect(states.single?.username, 'wanderer');

      await subscription.cancel();
    });

    test('rejects a duplicate email with EmailAlreadyInUseFailure', () async {
      await repository.signUp(username: 'first', email: 'dup@example.com', password: 'supersecret');

      final result = await repository.signUp(username: 'second', email: 'dup@example.com', password: 'supersecret');

      expect(result, const Left<Failure, dynamic>(EmailAlreadyInUseFailure()));
    });

    test('rejects a duplicate username with UsernameAlreadyInUseFailure', () async {
      await repository.signUp(username: 'dupuser', email: 'a@example.com', password: 'supersecret');

      final result = await repository.signUp(username: 'dupuser', email: 'b@example.com', password: 'supersecret');

      expect(result, const Left<Failure, dynamic>(UsernameAlreadyInUseFailure()));
    });

    test('rejects a weak password', () async {
      final result = await repository.signUp(username: 'weakpw', email: 'weak@example.com', password: '123');

      expect(result, const Left<Failure, dynamic>(WeakPasswordFailure()));
    });

    test('rejects an invalid email with a ValidationFailure', () async {
      final result = await repository.signUp(username: 'bademail', email: 'not-an-email', password: 'supersecret');

      expect(result.isLeft(), isTrue);
      result.match(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected a Left'),
      );
    });
  });

  group('logIn', () {
    test('succeeds with the correct password using either username or email', () async {
      await repository.signUp(username: 'loginuser', email: 'login@example.com', password: 'correcthorse');

      final byUsername = await repository.logIn(identifier: 'loginuser', password: 'correcthorse');
      final byEmail = await repository.logIn(identifier: 'login@example.com', password: 'correcthorse');

      expect(byUsername.isRight(), isTrue);
      expect(byEmail.isRight(), isTrue);
    });

    test('fails with InvalidCredentialsFailure for a wrong password', () async {
      await repository.signUp(username: 'wrongpw', email: 'wrongpw@example.com', password: 'correcthorse');

      final result = await repository.logIn(identifier: 'wrongpw', password: 'nope');

      expect(result, const Left<Failure, dynamic>(InvalidCredentialsFailure()));
    });

    test('fails with InvalidCredentialsFailure for an unknown identifier', () async {
      final result = await repository.logIn(identifier: 'ghost', password: 'whatever');

      expect(result, const Left<Failure, dynamic>(InvalidCredentialsFailure()));
    });
  });

  group('sendRecoveryEmail', () {
    test('accepts a valid email', () async {
      final result = await repository.sendRecoveryEmail(email: 'valid@example.com');
      expect(result, const Right<Failure, Unit>(unit));
    });

    test('rejects an invalid email', () async {
      final result = await repository.sendRecoveryEmail(email: 'not-an-email');
      expect(result.isLeft(), isTrue);
    });
  });

  test('skipRecovery always succeeds', () async {
    final result = await repository.skipRecovery();
    expect(result, const Right<Failure, Unit>(unit));
  });

  test('signOut clears the current user and emits null', () async {
    await repository.signUp(username: 'toSignOut', email: 'signout@example.com', password: 'supersecret');

    final states = <dynamic>[];
    final subscription = repository.watchAuthState().listen(states.add);

    final result = await repository.signOut();

    expect(result, const Right<Failure, Unit>(unit));
    expect(states, contains(null));

    await subscription.cancel();
  });
}
