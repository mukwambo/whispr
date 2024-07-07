import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffff4165),
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
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Unburden anonymously, boost\n your mental health.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xfffffefe),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xffff4165),
                    backgroundColor: const Color(0xfffffefe),
                  ),
                  onPressed: () {
                    // Navigate to the signInPage when the button is clicked
                    Navigator.pushNamed(context, '/signInPage');
                  },
                  child: const Text(
                    'Lets Get Started',
                    style: TextStyle(
                      color: Color(0xffff4165),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
