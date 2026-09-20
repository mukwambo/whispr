# Whispr

An anonymous mental-health venting app: *"Unburden anonymously."*

## Architecture

Feature-first Clean Architecture, with state management and dependency injection handled by [Riverpod](https://riverpod.dev), and routing by [go_router](https://pub.dev/packages/go_router).

```
lib/
  core/                     # cross-cutting, reusable across features
    theme/                  # design tokens (colors, text styles, spacing) + assembled ThemeData
    routing/                # go_router config, route paths, auth-guard redirects
    error/                  # Failure sealed class + Result<T> (fpdart Either alias)
    utils/                  # validators, shared across forms and the fake repository
    widgets/                # shared presentation widgets (buttons, text fields, social row, ...)
  features/
    intro/                  # splash screen, no domain/data layer needed
    auth/
      domain/               # entities, AuthRepository interface, use cases - pure, no Flutter imports
      data/                 # FakeAuthRepository (in-memory) - swap for a real backend here
      presentation/         # pages, Riverpod controllers/providers
    home/                   # placeholder authenticated landing page
```

**Adding a backend**: everything above the data layer depends only on the abstract
`AuthRepository` interface (`features/auth/domain/repositories/auth_repository.dart`). To
integrate Firebase, Supabase, or a custom REST API, write a new class implementing that
interface and swap it in at `authRepositoryProvider`
(`features/auth/presentation/providers/auth_providers.dart`) - no changes needed to use
cases, controllers, or pages.

**State management**: Riverpod `Provider`s double as the DI graph (repository → use cases →
controllers → pages). Async auth actions (sign up, log in, ...) are modeled with
`AsyncNotifier` controllers exposing `AsyncValue`, so pages render loading/error/success
declaratively via `ref.watch`/`ref.listen`.

**Routing & auth guards**: `goRouterProvider` (`core/routing/app_router.dart`) redirects
based on `authStateProvider`: signed-out users are bounced off any authenticated route back
to the intro screen, and signed-in users are bounced off the auth flow (sign in / login /
create account) to `/home`. The recovery-email step is reachable either way, since a user
lands there immediately after sign-up while already authenticated.

## Testing

Tests mirror `lib/` under `test/`. Run with:

```
flutter test
```

- **Unit tests**: use cases (against a `mocktail` mock of `AuthRepository`) and the
  `FakeAuthRepository`'s own behavior.
- **Widget tests**: auth pages, using `ProviderScope` overrides to inject a mocked
  repository and a scoped `GoRouter` to assert navigation.

Golden tests (locking in exact visual output) are a natural next addition once the design
stabilizes further, using `golden_toolkit` or `matchesGoldenFile`.

## Getting Started

This is a standard Flutter project:

```
flutter pub get
flutter run
```

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)
