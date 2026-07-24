import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whispr/features/auth/presentation/pages/create_account_page.dart';
import 'package:whispr/features/auth/presentation/pages/login_page.dart';
import 'package:whispr/features/auth/presentation/pages/recovery_email_page.dart';
import 'package:whispr/features/auth/presentation/pages/signin_page.dart';
import 'package:whispr/features/auth/presentation/providers/auth_providers.dart';
import 'package:whispr/features/chat/presentation/pages/chat_conversation_page.dart';
import 'package:whispr/features/chat/presentation/pages/chat_matching_page.dart';
import 'package:whispr/features/home/presentation/pages/home_page.dart';
import 'package:whispr/features/intro/presentation/pages/intro_page.dart';
import 'route_paths.dart';

const _authFlowPaths = {
  RoutePaths.intro,
  RoutePaths.signIn,
  RoutePaths.createAccount,
  RoutePaths.login,
};

/// Ticks whenever `authStateProvider` changes, telling go_router to
/// re-run `redirect`. Driven by `ref.listen` (not a second, independent
/// subscription to the underlying auth stream) so that by the time it
/// fires, `ref.read(authStateProvider)` inside `redirect` is guaranteed to
/// already reflect the new value - no race between two listeners of the
/// same stream.
class _AuthRefreshNotifier extends ChangeNotifier {
  void ping() => notifyListeners();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier();
  ref.listen(authStateProvider, (previous, next) => refreshNotifier.ping());
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RoutePaths.intro,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
      final target = state.matchedLocation;

      if (!isLoggedIn && !_authFlowPaths.contains(target) && target != RoutePaths.recoveryEmail) {
        return RoutePaths.intro;
      }

      // Recovery email is reachable right after sign-up, while already
      // authenticated - never bounce it to home.
      if (isLoggedIn && _authFlowPaths.contains(target)) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.intro,
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        path: RoutePaths.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: RoutePaths.createAccount,
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.recoveryEmail,
        builder: (context, state) => const RecoveryEmailPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.chatMatching,
        builder: (context, state) => const ChatMatchingPage(),
      ),
      GoRoute(
        path: RoutePaths.chat,
        builder: (context, state) => const ChatConversationPage(),
      ),
    ],
  );
});
