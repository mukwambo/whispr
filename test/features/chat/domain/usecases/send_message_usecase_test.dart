import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whispr/core/error/failure.dart';
import 'package:whispr/features/chat/domain/repositories/chat_repository.dart';
import 'package:whispr/features/chat/domain/usecases/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;
  late SendMessageUsecase usecase;

  setUp(() {
    repository = MockChatRepository();
    usecase = SendMessageUsecase(repository);
  });

  test('delegates to ChatRepository.sendMessage with the given text', () async {
    when(() => repository.sendMessage(text: 'hello')).thenAnswer((_) async => const Right(unit));

    final result = await usecase(text: 'hello');

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.sendMessage(text: 'hello')).called(1);
  });

  test('propagates an EmptyMessageFailure unchanged', () async {
    when(() => repository.sendMessage(text: any(named: 'text')))
        .thenAnswer((_) async => const Left(EmptyMessageFailure()));

    final result = await usecase(text: '');

    expect(result, const Left<Failure, Unit>(EmptyMessageFailure()));
  });
}
