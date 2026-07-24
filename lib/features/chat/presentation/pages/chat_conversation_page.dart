import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/widgets/text_link.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_providers.dart';
import '../providers/end_chat_controller.dart';
import '../providers/send_message_controller.dart';
import '../widgets/chat_crisis_banner.dart';
import '../widgets/chat_message_bubble.dart';

class ChatConversationPage extends ConsumerStatefulWidget {
  const ChatConversationPage({super.key});

  @override
  ConsumerState<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends ConsumerState<ChatConversationPage> {
  final _textController = TextEditingController();
  final _dismissedMessageIds = <String>{};

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    ref.read(sendMessageControllerProvider.notifier).submit(text: text);
  }

  Future<void> _endChat() async {
    await ref.read(endChatControllerProvider.notifier).submit();
    if (mounted) context.go(RoutePaths.home);
  }

  ChatMessage? _latestUndismissedFlaggedMessage(List<ChatMessage> messages) {
    for (final message in messages.reversed) {
      if (message.flaggedForSupport && !_dismissedMessageIds.contains(message.id)) {
        return message;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    ref.listen(sendMessageControllerProvider, (previous, next) {
      if (next.hasError) {
        final failure = next.error;
        final message = failure is Failure ? failure.message : 'Message not sent';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final session = ref.watch(chatSessionProvider).valueOrNull;
    final messagesAsync = ref.watch(chatMessagesProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(session?.otherPartyLabel ?? 'Chat'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: TextLink(text: 'End chat', onPressed: _endChat),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: messagesAsync.when(
                  data: (messages) => ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return ChatMessageBubble(message: message);
                    },
                  ),
                  loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
                  error: (error, stackTrace) => Center(
                    child: Text('Something went wrong', style: TextStyle(color: colors.inkMuted)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Builder(
                  builder: (context) {
                    final flagged = _latestUndismissedFlaggedMessage(messagesAsync.valueOrNull ?? []);
                    if (flagged == null) return const SizedBox.shrink();
                    return ChatCrisisBanner(
                      message: flagged,
                      onDismiss: () => setState(() => _dismissedMessageIds.add(flagged.id)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(hintText: 'Type a message...'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      icon: Icon(Icons.send, color: colors.primary),
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
