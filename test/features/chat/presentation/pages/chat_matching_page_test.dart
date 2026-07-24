import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/theme/app_theme.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/presentation/pages/chat_matching_page.dart';
import 'package:whispr/features/chat/presentation/providers/chat_providers.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository chatRepository;
  late StreamController<ChatSession?> sessionController;

  setUp(() {
    chatRepository = MockChatRepository();
    sessionController = StreamController<ChatSession?>.broadcast();
    when(() => chatRepository.watchSession()).thenAnswer((_) => sessionController.stream);
    when(() => chatRepository.endChat()).thenAnswer((_) async => const Right(unit));
  });

  tearDown(() => sessionController.close());

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/chat/matching',
      routes: [
        GoRoute(path: '/chat/matching', builder: (_, __) => const ChatMatchingPage()),
        GoRoute(path: '/chat', builder: (_, __) => const Scaffold(body: Text('Chat Screen'))),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home Screen'))),
      ],
    );
    return ProviderScope(
      overrides: [chatRepositoryProvider.overrideWithValue(chatRepository)],
      child: MaterialApp.router(theme: lightTheme, routerConfig: router),
    );
  }

  testWidgets('shows a venter-facing waiting message and navigates once active', (tester) async {
    await tester.pumpWidget(buildTestApp());
    sessionController.add(
      const ChatSession(
        id: 's1',
        myRole: ChatRole.venter,
        status: ChatSessionStatus.waiting,
        otherPartyLabel: 'Listener',
      ),
    );
    await tester.pump();

    expect(find.text('Looking for someone to listen...'), findsOneWidget);

    sessionController.add(
      const ChatSession(
        id: 's1',
        myRole: ChatRole.venter,
        status: ChatSessionStatus.active,
        otherPartyLabel: 'Listener',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chat Screen'), findsOneWidget);
  });

  testWidgets('shows a listener-facing waiting message', (tester) async {
    await tester.pumpWidget(buildTestApp());
    sessionController.add(
      const ChatSession(
        id: 's1',
        myRole: ChatRole.listener,
        status: ChatSessionStatus.waiting,
        otherPartyLabel: 'Someone who needs to talk',
      ),
    );
    await tester.pump();

    expect(find.text('Waiting for someone who needs an ear...'), findsOneWidget);
  });

  testWidgets('Cancel ends the chat and returns home', (tester) async {
    await tester.pumpWidget(buildTestApp());
    sessionController.add(
      const ChatSession(
        id: 's1',
        myRole: ChatRole.venter,
        status: ChatSessionStatus.waiting,
        otherPartyLabel: 'Listener',
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    verify(() => chatRepository.endChat()).called(1);
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
