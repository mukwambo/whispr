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
import 'package:whispr/core/widgets/quiet_back_app_bar.dart';
import 'package:whispr/core/widgets/text_link.dart';

import '../providers/log_in_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(logInControllerProvider.notifier).submit(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(logInControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        context.go(RoutePaths.home);
      } else if (next.hasError) {
        final failure = next.error;
        final message = failure is Failure ? failure.message : 'Something went wrong';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final isLoading = ref.watch(logInControllerProvider).isLoading;
    final colors = context.appColors;

    return Scaffold(
      appBar: const QuietBackAppBar(),
      body: CenteredFormBody(
        formKey: _formKey,
        children: [
          Text('Welcome back', style: AppTextStyles.pageTitle.copyWith(color: colors.ink)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Good to see you again.',
            style: AppTextStyles.subtitle.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _identifierController,
            labelText: 'Username',
            validator: Validators.identifier,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _passwordController,
            labelText: 'Password',
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.password,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextLink(
              text: 'Forgot password?',
              onPressed: () => context.go(RoutePaths.recoveryEmail),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Log in',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Terms of Service', style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint)),
              Text('  ·  ', style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint)),
              Text('Privacy policy', style: AppTextStyles.smallPrint.copyWith(color: colors.inkFaint)),
            ],
          ),
        ],
      ),
    );
  }
}
