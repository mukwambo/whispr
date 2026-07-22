import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/core/error/failure.dart';
import 'package:whispr/core/routing/route_paths.dart';
import 'package:whispr/core/theme/app_spacing.dart';
import 'package:whispr/core/theme/app_text_styles.dart';
import 'package:whispr/core/utils/validators.dart';
import 'package:whispr/core/widgets/app_text_field.dart';
import 'package:whispr/core/widgets/centered_form_body.dart';
import 'package:whispr/core/widgets/primary_button.dart';

import '../providers/sign_up_controller.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(signUpControllerProvider.notifier).submit(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signUpControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        context.go(RoutePaths.recoveryEmail);
      } else if (next.hasError) {
        final failure = next.error;
        final message = failure is Failure ? failure.message : 'Something went wrong';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final isLoading = ref.watch(signUpControllerProvider).isLoading;

    return Scaffold(
      body: CenteredFormBody(
        formKey: _formKey,
        children: [
          const Text('Create your account', style: AppTextStyles.pageTitle),
          const SizedBox(height: AppSpacing.xs),
          const Text('Your identity stays private. Always.', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _usernameController,
            labelText: 'Username',
            validator: Validators.username,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
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
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Create account',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.xl),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Terms of Service', style: AppTextStyles.smallPrint),
              Text('  ·  ', style: AppTextStyles.smallPrint),
              Text('Privacy policy', style: AppTextStyles.smallPrint),
            ],
          ),
        ],
      ),
    );
  }
}
