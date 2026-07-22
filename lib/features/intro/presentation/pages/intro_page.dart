import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Whispr',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Unburden anonymously, boost\n your mental health.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.onPrimary,
                  ),
                  onPressed: () => context.go(RoutePaths.signIn),
                  child: const Text(
                    "Let's get started",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
