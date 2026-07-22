import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/widgets/primary_button.dart';
import 'package:whispr/features/auth/presentation/providers/auth_providers.dart';

/// Placeholder landing page for authenticated users. The app has no
/// post-auth product surface yet; this exists so the auth flow (sign up,
/// log in) has somewhere real to land, and so sign-out can be exercised.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

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
                style: AppTextStyles.pageTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Sign Out',
                onPressed: () => ref.read(signOutUsecaseProvider)(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
