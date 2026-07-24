import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/domain/usecases/request_chat_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ChatRole.venter);
  });

  late MockChatRepository repository;
  late RequestChatUsecase usecase;

  setUp(() {
    repository = MockChatRepository();
    usecase = RequestChatUsecase(repository);
  });

  test('delegates to ChatRepository.requestChat with the given role', () async {
    when(() => repository.requestChat(role: ChatRole.venter)).thenAnswer((_) async => const Right(unit));

    final result = await usecase(role: ChatRole.venter);

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.requestChat(role: ChatRole.venter)).called(1);
  });

  test('propagates a failure unchanged', () async {
    when(() => repository.requestChat(role: any(named: 'role')))
        .thenAnswer((_) async => const Left(ChatSessionAlreadyActiveFailure()));

    final result = await usecase(role: ChatRole.listener);

    expect(result, const Left<Failure, Unit>(ChatSessionAlreadyActiveFailure()));
  });
}
