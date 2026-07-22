import 'package:equatable/equatable.dart';

/// Credentials used to log in. [identifier] is either a username or email.
class AuthCredentials extends Equatable {
  final String identifier;
  final String password;

  const AuthCredentials({
    required this.identifier,
    required this.password,
  });

  @override
  List<Object?> get props => [identifier, password];
}
