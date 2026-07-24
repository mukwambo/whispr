import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whispr/core/routing/app_router.dart';
import 'package:whispr/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Whispr',
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
