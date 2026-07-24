import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/chat/domain/entities/chat_message.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/data/repositories/fake_chat_repository.dart';

/// Lets zero-duration `Timer`s scheduled inside the repository fire before
/// assertions run. Call once per level of chained timers (e.g. match ->
/// opener is two levels).
Future<void> _flush() => Future<void>.delayed(Duration.zero);

FakeChatRepository _buildRepository() => FakeChatRepository(
      matchDelay: Duration.zero,
      openerDelay: Duration.zero,
      replyDelay: Duration.zero,
    );

void main() {
  late FakeChatRepository repository;
  late List<ChatSession?> sessions;
  late List<List<ChatMessage>> messageSnapshots;

  setUp(() {
    repository = _buildRepository();
    sessions = [];
    messageSnapshots = [];
    // Broadcast streams don't replay past events to a late subscriber, so
    // every test listens from the start and asserts against the collected
    // history (usually `.last`) rather than calling `.first` mid-test.
    repository.watchSession().listen(sessions.add);
    repository.watchMessages().listen(messageSnapshots.add);
  });

  tearDown(() {
    repository.dispose();
  });

  group('requestChat', () {
    test('transitions waiting -> active and delivers a venter-facing opener', () async {
      final result = await repository.requestChat(role: ChatRole.venter);
      expect(result.isRight(), isTrue);
      expect(sessions.last?.status, ChatSessionStatus.waiting);

      await _flush();
      await _flush();

      expect(sessions.last?.status, ChatSessionStatus.active);
      expect(sessions.last?.otherPartyLabel, 'Listener');

      final messages = messageSnapshots.last;
      expect(messages, hasLength(1));
      expect(messages.single.sender, ChatMessageSender.other);
      expect(messages.single.flaggedForSupport, isFalse);
    });

    test('as a listener, seeds a scripted opener flagged for support', () async {
      await repository.requestChat(role: ChatRole.listener);
      await _flush();
      await _flush();

      final messages = messageSnapshots.last;
      expect(messages, hasLength(1));
      expect(messages.single.sender, ChatMessageSender.other);
      expect(messages.single.flaggedForSupport, isTrue);
    });

    test('fails if a session is already active', () async {
      await repository.requestChat(role: ChatRole.venter);

      final result = await repository.requestChat(role: ChatRole.listener);

      expect(result, const Left<Failure, dynamic>(ChatSessionAlreadyActiveFailure()));
    });
  });

  group('sendMessage', () {
    test('rejects empty text', () async {
      await repository.requestChat(role: ChatRole.venter);
      await _flush();
      await _flush();

      final result = await repository.sendMessage(text: '   ');

      expect(result, const Left<Failure, dynamic>(EmptyMessageFailure()));
    });

    test('fails when there is no active session', () async {
      final result = await repository.sendMessage(text: 'hello');

      expect(result.isLeft(), isTrue);
    });

    test('flags crisis language and schedules an other-reply', () async {
      await repository.requestChat(role: ChatRole.venter);
      await _flush();
      await _flush();

      final result = await repository.sendMessage(text: 'I want to die');
      expect(result.isRight(), isTrue);

      final mine = messageSnapshots.last.firstWhere((m) => m.sender == ChatMessageSender.me);
      expect(mine.flaggedForSupport, isTrue);

      await _flush();

      final otherMessages = messageSnapshots.last.where((m) => m.sender == ChatMessageSender.other);
      expect(otherMessages, hasLength(2));
    });
  });

  group('endChat', () {
    test('cancels pending timers so no opener arrives after ending early', () async {
      await repository.requestChat(role: ChatRole.venter);
      await repository.endChat();
      await _flush();
      await _flush();

      expect(sessions.last?.status, ChatSessionStatus.ended);
      expect(messageSnapshots.last, isEmpty);
    });

    test('a following requestChat starts with a clean message list', () async {
      await repository.requestChat(role: ChatRole.venter);
      await _flush();
      await _flush();
      await repository.sendMessage(text: 'hi');
      await _flush();
      await repository.endChat();

      final result = await repository.requestChat(role: ChatRole.listener);
      expect(result.isRight(), isTrue);

      // The clear-and-reset emission happens synchronously inside
      // requestChat, before its scripted opener (scheduled, not yet fired).
      expect(messageSnapshots.last, isEmpty);
    });
  });

  test('dispose cancels timers without throwing on pending callbacks', () async {
    await repository.requestChat(role: ChatRole.venter);
    repository.dispose();

    await _flush();
    await _flush();
  });
}
