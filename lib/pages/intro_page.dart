import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffff4165),
      body: SafeArea(
        child: Center(
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
                'Unburden anonymously,\nboost your mental health.',
                style: TextStyle(
                  color: Color(0xfffffefe),
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xffff4165),
                    backgroundColor: const Color(0xfffffefe),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Lets Get Started',
                    style: TextStyle(
                      color: Color(0xffff4165),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
