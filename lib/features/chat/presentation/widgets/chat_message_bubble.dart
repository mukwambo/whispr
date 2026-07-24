import 'package:flutter/material.dart';

import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/features/chat/domain/entities/chat_message.dart';

/// A single message bubble. Reuses the app's existing color tokens only -
/// no bubble-specific colors: "me" is `primary`/`onPrimary` (the same pair
/// used for the primary CTA elsewhere), "other" is `surface`/`ink` with a
/// `divider` border, matching how fields are styled.
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMe = message.sender == ChatMessageSender.me;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? colors.primary : colors.surface,
            border: isMe ? null : Border.all(color: colors.divider),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: isMe ? colors.onPrimary : colors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
