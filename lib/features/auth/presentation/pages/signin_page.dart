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
              const Text(
                'Continue to your account',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Create an account',
                onPressed: () => context.go(RoutePaths.createAccount),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: AppTextStyles.subtitle),
                  TextLink(
                    text: 'Log in',
                    onPressed: () => context.go(RoutePaths.login),
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
