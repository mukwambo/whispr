import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/widgets/text_link.dart';
import '../../domain/entities/chat_session.dart';
import '../providers/chat_providers.dart';
import '../providers/end_chat_controller.dart';

/// Shown while [FakeChatRepository] simulates finding a match. Watches
/// [chatSessionProvider] and moves on to the conversation once a real
/// backend (or, today, the fake) reports the session as active.
class ChatMatchingPage extends ConsumerWidget {
  const ChatMatchingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final session = ref.watch(chatSessionProvider).valueOrNull;

    // Checked on every build (not just via `ref.listen` transitions) so a
    // session that's already active by the time this page first mounts -
    // e.g. matching finished while navigation here was still in flight -
    // still redirects, instead of only reacting to a future change.
    if (session?.status == ChatSessionStatus.active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.chat);
      });
    }

    final isListener = session?.myRole == ChatRole.listener;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: colors.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  isListener
                      ? 'Waiting for someone who needs an ear...'
                      : 'Looking for someone to listen...',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextLink(
                  text: 'Cancel',
                  style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint),
                  onPressed: () async {
                    await ref.read(endChatControllerProvider.notifier).submit();
                    if (context.mounted) context.go(RoutePaths.home);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
