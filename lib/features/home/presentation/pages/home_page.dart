import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/widgets/primary_button.dart';
import 'package:whispr/core/widgets/text_link.dart';
import 'package:whispr/features/auth/presentation/providers/auth_providers.dart';
import 'package:whispr/features/chat/domain/entities/chat_session.dart';
import 'package:whispr/features/chat/presentation/providers/chat_providers.dart';
import 'package:whispr/features/chat/presentation/providers/request_chat_controller.dart';

/// The real entry point to the app's core feature: choosing to vent or to
/// listen. Anyone can do either, per chat - no separate listener role yet.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(requestChatControllerProvider, (previous, next) {
      // Deferred to the next frame: `chatSessionProvider`'s stream fires
      // synchronously from within the same repository call this
      // controller awaits, which can mark this element dirty for a
      // rebuild in the same notification pass. Pushing immediately here
      // races that pending rebuild and can get silently dropped -
      // scheduling after the frame guarantees a clean, settled tree.
      if (next.hasValue && next.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.push(RoutePaths.chatMatching);
        });
      } else if (next.hasError) {
        final failure = next.error;
        final message = failure is Failure ? failure.message : 'Something went wrong';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        });
      }
    });

    final user = ref.watch(authStateProvider).valueOrNull;
    final colors = context.appColors;
    final session = ref.watch(chatSessionProvider).valueOrNull;
    final hasActiveSession = session != null && session.status != ChatSessionStatus.ended;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user?.username != null ? "You're in, ${user!.username}." : "You're in.",
                textAlign: TextAlign.center,
                style: AppTextStyles.pageTitle.copyWith(color: colors.ink),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                hasActiveSession
                    ? 'You have a chat waiting for you.'
                    : 'Whenever you\'re ready.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (hasActiveSession)
                PrimaryButton(
                  label: 'Resume chat',
                  onPressed: () => context.push(
                    session.status == ChatSessionStatus.active
                        ? RoutePaths.chat
                        : RoutePaths.chatMatching,
                  ),
                )
              else ...[
                PrimaryButton(
                  label: 'Start venting',
                  onPressed: () => ref.read(requestChatControllerProvider.notifier).submit(role: ChatRole.venter),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: 'Offer to listen',
                  onPressed: () => ref.read(requestChatControllerProvider.notifier).submit(role: ChatRole.listener),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              TextLink(
                text: 'Sign out',
                style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint),
                onPressed: () => ref.read(signOutUsecaseProvider)(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
