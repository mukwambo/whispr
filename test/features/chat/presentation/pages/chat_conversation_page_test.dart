import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/theme/app_theme.dart';
import 'package:whispr/features/chat/domain/entities/chat_message.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/presentation/pages/chat_conversation_page.dart';
import 'package:whispr/features/chat/presentation/providers/chat_providers.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository chatRepository;
  late StreamController<ChatSession?> sessionController;
  late StreamController<List<ChatMessage>> messagesController;

  setUp(() {
    chatRepository = MockChatRepository();
    sessionController = StreamController<ChatSession?>.broadcast();
    messagesController = StreamController<List<ChatMessage>>.broadcast();
    when(() => chatRepository.watchSession()).thenAnswer((_) => sessionController.stream);
    when(() => chatRepository.watchMessages()).thenAnswer((_) => messagesController.stream);
    when(() => chatRepository.endChat()).thenAnswer((_) async => const Right(unit));
  });

  tearDown(() {
    sessionController.close();
    messagesController.close();
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: '/chat',
      routes: [
        GoRoute(path: '/chat', builder: (_, __) => const ChatConversationPage()),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home Screen'))),
      ],
    );
    return ProviderScope(
      overrides: [chatRepositoryProvider.overrideWithValue(chatRepository)],
      child: MaterialApp.router(theme: lightTheme, routerConfig: router),
    );
  }

  const activeSession = ChatSession(
    id: 's1',
    myRole: ChatRole.venter,
    status: ChatSessionStatus.active,
    otherPartyLabel: 'Listener',
  );

  testWidgets('sending a message calls sendMessage and the result renders as a bubble', (tester) async {
    when(() => chatRepository.sendMessage(text: any(named: 'text'))).thenAnswer((invocation) async {
      final text = invocation.namedArguments[#text] as String;
      messagesController.add([
        ChatMessage(id: 'm1', sender: ChatMessageSender.me, text: text, sentAt: DateTime(2026)),
      ]);
      return const Right(unit);
    });

    await tester.pumpWidget(buildTestApp());
    sessionController.add(activeSession);
    messagesController.add(const []);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Hello there');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    verify(() => chatRepository.sendMessage(text: 'Hello there')).called(1);
    expect(find.text('Hello there'), findsOneWidget);
  });

  testWidgets('shows the self-facing crisis banner for a flagged message from me', (tester) async {
    await tester.pumpWidget(buildTestApp());
    sessionController.add(activeSession);
    messagesController.add([
      ChatMessage(
        id: 'm1',
        sender: ChatMessageSender.me,
        text: 'I want to die',
        sentAt: DateTime(2026),
        flaggedForSupport: true,
      ),
    ]);
    await tester.pump();

    expect(find.textContaining('988 Suicide & Crisis Lifeline'), findsOneWidget);
    expect(find.textContaining("It sounds like you're carrying"), findsOneWidget);
  });

  testWidgets('shows the listener-facing crisis banner for a flagged message from other', (tester) async {
    await tester.pumpWidget(buildTestApp());
    sessionController.add(
      const ChatSession(
        id: 's1',
        myRole: ChatRole.listener,
        status: ChatSessionStatus.active,
        otherPartyLabel: 'Someone who needs to talk',
      ),
    );
    messagesController.add([
      ChatMessage(
        id: 'm1',
        sender: ChatMessageSender.other,
        text: 'I want to die',
        sentAt: DateTime(2026),
        flaggedForSupport: true,
      ),
    ]);
    await tester.pump();

    expect(find.textContaining('may be going through a crisis'), findsOneWidget);
  });

  testWidgets('shows an error snackbar when sending fails', (tester) async {
    when(() => chatRepository.sendMessage(text: any(named: 'text')))
        .thenAnswer((_) async => const Left(UnknownFailure('Message not sent')));

    await tester.pumpWidget(buildTestApp());
    sessionController.add(activeSession);
    messagesController.add(const []);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('Message not sent'), findsOneWidget);
  });
}
