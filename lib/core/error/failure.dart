/// Base type for expected, user-facing failures. Domain and data layers
/// return these instead of throwing, so presentation code never has to
/// wrap repository calls in try/catch for expected error cases.
sealed class Failure {
  final String message;

  const Failure(this.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid username or password');
}

/// A field failed client-side validation (e.g. weak username). Carries the
/// specific validator message so the UI can show it inline.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure() : super('Email already registered');
}

class UsernameAlreadyInUseFailure extends Failure {
  const UsernameAlreadyInUseFailure() : super('Username already taken');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure() : super('Password is too weak');
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Please enter a valid email address');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Network error, please try again');
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
