import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/auth/domain/entities/auth_result.dart';
import 'package:whispr/features/auth/domain/entities/user.dart';
import 'package:whispr/features/auth/domain/repositories/auth_repository.dart';
import 'package:whispr/features/auth/presentation/pages/create_account_page.dart';
import 'package:whispr/features/auth/presentation/providers/auth_providers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.watchAuthState()).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/create-account',
      routes: [
        GoRoute(path: '/create-account', builder: (_, __) => const CreateAccountPage()),
        GoRoute(
          path: '/recovery-email',
          builder: (_, __) => const Scaffold(body: Text('Recovery Email Screen')),
        ),
      ],
    );
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  Finder usernameField() => find.byType(TextFormField).at(0);
  Finder emailField() => find.byType(TextFormField).at(1);
  Finder passwordField() => find.byType(TextFormField).at(2);

  testWidgets('shows validation errors and never calls the repository when fields are empty',
      (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => repository.signUp(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });

  testWidgets('navigates to the recovery email screen on successful sign up', (tester) async {
    when(() => repository.signUp(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Right(AuthResult(user: User(id: 'u1', username: 'wanderer'), isNewUser: true)),
    );

    await tester.pumpWidget(buildTestApp());
    await tester.enterText(usernameField(), 'wanderer');
    await tester.enterText(emailField(), 'wanderer@example.com');
    await tester.enterText(passwordField(), 'correcthorsebattery');

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Recovery Email Screen'), findsOneWidget);
  });

  testWidgets('shows a snackbar with the failure message and stays on the page', (tester) async {
    when(() => repository.signUp(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Left(EmailAlreadyInUseFailure()));

    await tester.pumpWidget(buildTestApp());
    await tester.enterText(usernameField(), 'wanderer');
    await tester.enterText(emailField(), 'taken@example.com');
    await tester.enterText(passwordField(), 'correcthorsebattery');

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Email already registered'), findsOneWidget);
    expect(find.text('Recovery Email Screen'), findsNothing);
  });
}
