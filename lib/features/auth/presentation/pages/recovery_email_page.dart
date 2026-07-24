import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_colors.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/utils/validators.dart';
import 'package:whispr/core/widgets/app_text_field.dart';
import 'package:whispr/core/widgets/centered_form_body.dart';
import 'package:whispr/core/widgets/primary_button.dart';
import 'package:whispr/core/widgets/text_link.dart';

import '../providers/recovery_email_controller.dart';

class RecoveryEmailPage extends ConsumerStatefulWidget {
  const RecoveryEmailPage({super.key});

  @override
  ConsumerState<RecoveryEmailPage> createState() => _RecoveryEmailPageState();
}

class _RecoveryEmailPageState extends ConsumerState<RecoveryEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(recoveryEmailControllerProvider.notifier).sendRecoveryEmail(
          email: _emailController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(recoveryEmailControllerProvider, (previous, next) {
      if (next.hasError) {
        final failure = next.error;
        final message = failure is Failure ? failure.message : 'Something went wrong';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      } else if (!next.isLoading && (previous?.isLoading ?? false)) {
        context.go(RoutePaths.home);
      }
    });

    final isLoading = ref.watch(recoveryEmailControllerProvider).isLoading;
    final colors = context.appColors;

    return Scaffold(
      body: CenteredFormBody(
        formKey: _formKey,
        children: [
          Text('Add a recovery email', style: AppTextStyles.pageTitle.copyWith(color: colors.ink)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "We'll only ever use this to help you back in - nothing else.",
            style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Continue',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextLink(
              text: 'Skip for now',
              style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint),
              onPressed: isLoading
                  ? null
                  : () => ref.read(recoveryEmailControllerProvider.notifier).skip(),
            ),
          ),
        ],
      ),
    );
  }
}
