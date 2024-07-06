import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // This list allows us to use a listViewBuilder to return Chips for the labels' design
  final List<String> loginLabels = const ['Sign In', 'Sign Up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
              child: TextButton(
                onPressed: () {
                  // Navigate to the SignUp when the button is clicked
                },
                child: const Text(
                  'Create An Account',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
              child: TextButton(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
