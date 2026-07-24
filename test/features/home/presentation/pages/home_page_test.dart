import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/theme/app_theme.dart';
import 'package:whispr/features/auth/domain/entities/user.dart';
import 'package:whispr/features/auth/domain/repositories/auth_repository.dart';
import 'package:whispr/features/auth/presentation/providers/auth_providers.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/presentation/providers/chat_providers.dart';
import 'package:whispr/features/home/presentation/pages/home_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ChatRole.venter);
  });

  late MockAuthRepository authRepository;
  late MockChatRepository chatRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    chatRepository = MockChatRepository();
    when(() => authRepository.watchAuthState()).thenAnswer(
      (_) => Stream.value(const User(id: 'u1', username: 'wanderer')),
    );
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(
          path: '/chat/matching',
          builder: (_, __) => const Scaffold(body: Text('Matching Screen')),
        ),
        GoRoute(path: '/chat', builder: (_, __) => const Scaffold(body: Text('Chat Screen'))),
      ],
    );
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        chatRepositoryProvider.overrideWithValue(chatRepository),
      ],
      child: MaterialApp.router(theme: lightTheme, routerConfig: router),
    );
  }

  testWidgets('shows the venter/listener choice when there is no active session', (tester) async {
    when(() => chatRepository.watchSession()).thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(buildTestApp());
    await tester.pump();

    expect(find.text("You're in, wanderer."), findsOneWidget);
    expect(find.text('Start venting'), findsOneWidget);
    expect(find.text('Offer to listen'), findsOneWidget);
  });

  testWidgets('tapping "Start venting" requests a venter chat and navigates to matching', (tester) async {
    when(() => chatRepository.watchSession()).thenAnswer((_) => Stream.value(null));
    when(() => chatRepository.requestChat(role: ChatRole.venter)).thenAnswer((_) async => const Right(unit));

    await tester.pumpWidget(buildTestApp());
    await tester.pump();

    await tester.tap(find.text('Start venting'));
    await tester.pumpAndSettle();

    verify(() => chatRepository.requestChat(role: ChatRole.venter)).called(1);
    expect(find.text('Matching Screen'), findsOneWidget);
  });

  testWidgets('shows "Resume chat" instead of the choice when a session is already active', (tester) async {
    const session = ChatSession(
      id: 's1',
      myRole: ChatRole.venter,
      status: ChatSessionStatus.active,
      otherPartyLabel: 'Listener',
    );
    when(() => chatRepository.watchSession()).thenAnswer((_) => Stream.value(session));

    await tester.pumpWidget(buildTestApp());
    await tester.pump();

    expect(find.text('Resume chat'), findsOneWidget);
    expect(find.text('Start venting'), findsNothing);

    await tester.tap(find.text('Resume chat'));
    await tester.pumpAndSettle();

    expect(find.text('Chat Screen'), findsOneWidget);
  });
}
