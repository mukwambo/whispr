import 'package:equatable/equatable.dart';

enum ChatMessageSender { me, other }

class ChatMessage extends Equatable {
  final String id;
  final ChatMessageSender sender;
  final String text;
  final DateTime sentAt;

  /// True when this message tripped [CrisisDetector] (or, for a scripted
  /// fake "other" message, was seeded as such). Set regardless of sender -
  /// a listener seeing a flagged message from the venter is at least as
  /// important as a venter seeing it in their own message.
  final bool flaggedForSupport;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.sentAt,
    this.flaggedForSupport = false,
  });

  @override
  List<Object?> get props => [id, sender, text, sentAt, flaggedForSupport];
}
