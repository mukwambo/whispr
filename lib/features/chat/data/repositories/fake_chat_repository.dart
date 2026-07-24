import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/error/result.dart';
import 'package:whispr/core/utils/crisis_detector.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chat_repository.dart';

/// In-memory implementation of [ChatRepository]. Ships today so the chat
/// feature is fully usable and demoable on one device before a real
/// backend (matching, real-time transport, encryption in transit/at rest)
/// exists - the "other party" is simulated: a scripted opener followed by
/// canned, rotating replies, standing in for a real matched human, same
/// spirit as `FakeAuthRepository`.
class FakeChatRepository implements ChatRepository {
  FakeChatRepository({
    this.matchDelay = const Duration(milliseconds: 1200),
    this.openerDelay = const Duration(milliseconds: 900),
    this.replyDelay = const Duration(milliseconds: 1400),
  });

  final Duration matchDelay;
  final Duration openerDelay;
  final Duration replyDelay;

  static const _listenerReplies = [
    "That sounds really hard. I'm glad you're sharing this with me.",
    "I hear you. Do you want to tell me more about what's been going on?",
    "You're not alone in feeling this way.",
    "Thank you for trusting me with this.",
    "That makes a lot of sense given what you've described.",
  ];

  static const _venterReplies = [
    "I don't know, it just feels like everything is piling up lately.",
    "Yeah... I haven't really told anyone this before.",
    "It's been like this for a few weeks now.",
    "Thanks for listening, it actually helps to say it out loud.",
    "I guess I just needed someone to hear it.",
  ];

  final _sessionController = StreamController<ChatSession?>.broadcast();
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  final _pendingTimers = <Timer>{};

  ChatSession? _session;
  final List<ChatMessage> _messages = [];
  int _sessionCounter = 0;
  int _messageCounter = 0;
  int _replyIndex = 0;
  bool _disposed = false;

  @override
  Stream<ChatSession?> watchSession() async* {
    // A broadcast stream doesn't replay history to a late subscriber -
    // yield the current snapshot first so a widget that starts watching
    // after state already changed (e.g. `ChatConversationPage`, mounted
    // only once matching completes) doesn't miss it.
    yield _session;
    yield* _sessionController.stream;
  }

  @override
  Stream<List<ChatMessage>> watchMessages() async* {
    yield List.unmodifiable(_messages);
    yield* _messagesController.stream;
  }

  @override
  Future<Result<Unit>> requestChat({required ChatRole role}) async {
    if (_session != null && _session!.status != ChatSessionStatus.ended) {
      return const Left(ChatSessionAlreadyActiveFailure());
    }

    _messages.clear();
    _emitMessages();

    final session = ChatSession(
      id: 'session-${++_sessionCounter}',
      myRole: role,
      status: ChatSessionStatus.waiting,
      otherPartyLabel: role == ChatRole.venter ? 'Listener' : 'Someone who needs to talk',
    );
    _session = session;
    _sessionController.add(session);

    _schedule(matchDelay, () {
      final active = ChatSession(
        id: session.id,
        myRole: session.myRole,
        status: ChatSessionStatus.active,
        otherPartyLabel: session.otherPartyLabel,
      );
      _session = active;
      _sessionController.add(active);

      _schedule(openerDelay, () => _sendOpener(role));
    });

    return const Right(unit);
  }

  @override
  Future<Result<Unit>> sendMessage({required String text}) async {
    if (text.trim().isEmpty) {
      return const Left(EmptyMessageFailure());
    }
    if (_session == null || _session!.status != ChatSessionStatus.active) {
      return const Left(UnknownFailure('No active chat to send a message to'));
    }

    _messages.add(ChatMessage(
      id: 'message-${++_messageCounter}',
      sender: ChatMessageSender.me,
      text: text,
      sentAt: DateTime.now(),
      flaggedForSupport: CrisisDetector.containsCrisisSignal(text),
    ));
    _emitMessages();

    final replies = _session!.myRole == ChatRole.venter ? _listenerReplies : _venterReplies;
    _schedule(replyDelay, () {
      _messages.add(ChatMessage(
        id: 'message-${++_messageCounter}',
        sender: ChatMessageSender.other,
        text: replies[_replyIndex++ % replies.length],
        sentAt: DateTime.now(),
      ));
      _emitMessages();
    });

    return const Right(unit);
  }

  @override
  Future<Result<Unit>> endChat() async {
    _cancelPendingTimers();
    if (_session != null) {
      final ended = ChatSession(
        id: _session!.id,
        myRole: _session!.myRole,
        status: ChatSessionStatus.ended,
        otherPartyLabel: _session!.otherPartyLabel,
      );
      _session = ended;
      _sessionController.add(ended);
    }
    return const Right(unit);
  }

  void _sendOpener(ChatRole myRole) {
    final ChatMessage opener;
    if (myRole == ChatRole.venter) {
      opener = ChatMessage(
        id: 'message-${++_messageCounter}',
        sender: ChatMessageSender.other,
        text: "Hi, I'm here. What's on your mind?",
        sentAt: DateTime.now(),
      );
    } else {
      // Deliberately alarming, flagged directly rather than run through
      // CrisisDetector, so the listener-facing crisis banner is
      // exercisable in the fake without needing real detection on
      // scripted text.
      opener = ChatMessage(
        id: 'message-${++_messageCounter}',
        sender: ChatMessageSender.other,
        text: "Hey... honestly I don't really see the point in anything anymore. Sorry to just dump this on you.",
        sentAt: DateTime.now(),
        flaggedForSupport: true,
      );
    }
    _messages.add(opener);
    _emitMessages();
  }

  void _emitMessages() {
    _messagesController.add(List.unmodifiable(_messages));
  }

  void _schedule(Duration delay, void Function() action) {
    late final Timer timer;
    timer = Timer(delay, () {
      _pendingTimers.remove(timer);
      if (_disposed) return;
      action();
    });
    _pendingTimers.add(timer);
  }

  void _cancelPendingTimers() {
    for (final timer in _pendingTimers) {
      timer.cancel();
    }
    _pendingTimers.clear();
  }

  void dispose() {
    _disposed = true;
    _cancelPendingTimers();
    _sessionController.close();
    _messagesController.close();
  }
}
