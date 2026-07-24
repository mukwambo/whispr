import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/widgets/primary_button.dart';
import 'package:whispr/core/widgets/text_link.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Whispr',
                style: TextStyle(
                  fontSize: 55,
                  fontFamily: 'Pacifico',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Continue to your account',
                style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Create an account',
                onPressed: () => context.push(RoutePaths.createAccount),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
                  ),
                  TextLink(
                    text: 'Log in',
                    onPressed: () => context.push(RoutePaths.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
