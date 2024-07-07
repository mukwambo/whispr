import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  // This list allows us to use a listViewBuilder to return Chips for the labels' design
  final List<String> loginLabels = const ['Sign In', 'Sign Up'];

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
                  color: Color(0xffff4165),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the SignUp when the button is clicked
                  Navigator.pushNamed(context, '/createAccount');
                },
                child: const Text(
                  'Create An Account',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xfffffefe),
                  foregroundColor: const Color(0xffff4165),
                ),
                onPressed: () {
                  // Navigate to the LogIn page when the button is clicked
                },
                child: const Text(
                  'LogIn',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
