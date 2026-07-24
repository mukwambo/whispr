import 'package:flutter/material.dart';

import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/features/chat/domain/entities/chat_message.dart';

/// Shown inline in the chat when a message is flagged by [CrisisDetector]
/// (or, for a scripted fake message, seeded as flagged). Two variants,
/// because the person reading a flagged message matters as much as who
/// wrote it - a listener seeing something alarming from the venter is at
/// least as important a moment as a venter seeing it in their own message.
///
/// Copy is a placeholder: it needs localization and legal/clinical review
/// before this app is used in production.
class ChatCrisisBanner extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onDismiss;

  const ChatCrisisBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isSelf = message.sender == ChatMessageSender.me;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              isSelf ? _selfFacingMessage : _listenerFacingMessage,
              style: TextStyle(fontSize: 13, height: 1.5, color: colors.ink),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: colors.inkFaint),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  static const _selfFacingMessage = "It sounds like you're carrying something really heavy right now. "
      'You deserve support beyond this chat. The 988 Suicide & Crisis Lifeline is '
      'free, confidential, and available 24/7 - call or text 988.';

  static const _listenerFacingMessage =
      'The person you\'re talking with may be going through a crisis. You don\'t '
      'have to fix this alone - it\'s okay to gently point them to the 988 Suicide '
      '& Crisis Lifeline (call or text 988, free and confidential, 24/7). If you '
      'believe they\'re in immediate danger, encourage them to contact 911 or '
      'local emergency services.';
}
