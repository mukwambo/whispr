import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/chat/domain/entities/chat_message.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/domain/usecases/end_chat_usecase.dart';
import 'package:whispr/features/chat/domain/usecases/watch_chat_messages_usecase.dart';
import 'package:whispr/features/chat/domain/usecases/watch_chat_session_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;

  setUp(() {
    repository = MockChatRepository();
  });

  test('EndChatUsecase delegates to the repository', () async {
    when(() => repository.endChat()).thenAnswer((_) async => const Right(unit));

    final result = await EndChatUsecase(repository).call();

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.endChat()).called(1);
  });

  test('WatchChatSessionUsecase forwards the repository stream', () async {
    const session = ChatSession(
      id: 's1',
      myRole: ChatRole.venter,
      status: ChatSessionStatus.active,
      otherPartyLabel: 'Listener',
    );
    when(() => repository.watchSession()).thenAnswer((_) => Stream.value(session));

    final result = await WatchChatSessionUsecase(repository).call().first;

    expect(result, session);
    verify(() => repository.watchSession()).called(1);
  });

  test('WatchChatMessagesUsecase forwards the repository stream', () async {
    final messages = [
      ChatMessage(id: 'm1', sender: ChatMessageSender.other, text: 'hi', sentAt: DateTime(2026)),
    ];
    when(() => repository.watchMessages()).thenAnswer((_) => Stream.value(messages));

    final result = await WatchChatMessagesUsecase(repository).call().first;

    expect(result, messages);
    verify(() => repository.watchMessages()).called(1);
  });
}
