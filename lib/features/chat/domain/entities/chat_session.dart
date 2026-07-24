import 'package:equatable/equatable.dart';

/// Which side of the conversation the current user is on. Symmetric by
/// design - anyone can choose either, per chat, with no separate account
/// type.
enum ChatRole { venter, listener }

enum ChatSessionStatus { waiting, active, ended }

class ChatSession extends Equatable {
  final String id;
  final ChatRole myRole;
  final ChatSessionStatus status;

  /// A pseudonymous display label for the other party (e.g. "Listener") -
  /// never a real identity. Mutual anonymity is the point of this app.
  final String otherPartyLabel;

  const ChatSession({
    required this.id,
    required this.myRole,
    required this.status,
    required this.otherPartyLabel,
  });

  @override
  List<Object?> get props => [id, myRole, status, otherPartyLabel];
}
