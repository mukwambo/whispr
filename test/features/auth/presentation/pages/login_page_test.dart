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
import 'package:whispr/features/auth/presentation/pages/login_page.dart';
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
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home Screen'))),
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

  Finder identifierField() => find.byType(TextFormField).at(0);
  Finder passwordField() => find.byType(TextFormField).at(1);

  testWidgets('shows an error snackbar for invalid credentials', (tester) async {
    when(() => repository.logIn(
          identifier: any(named: 'identifier'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Left(InvalidCredentialsFailure()));

    await tester.pumpWidget(buildTestApp());
    await tester.enterText(identifierField(), 'someone');
    await tester.enterText(passwordField(), 'wrongpassword');

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password'), findsOneWidget);
    expect(find.text('Home Screen'), findsNothing);
  });

  testWidgets('navigates home on successful log in', (tester) async {
    when(() => repository.logIn(
          identifier: any(named: 'identifier'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Right(AuthResult(user: User(id: 'u1', username: 'wanderer'), isNewUser: false)),
    );

    await tester.pumpWidget(buildTestApp());
    await tester.enterText(identifierField(), 'wanderer');
    await tester.enterText(passwordField(), 'correcthorsebattery');

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('"Forgot password?" navigates to the recovery email screen', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.text('Recovery Email Screen'), findsOneWidget);
  });
}
