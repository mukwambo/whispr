import 'package:equatable/equatable.dart';

import 'user.dart';

class AuthResult extends Equatable {
  final User user;
  final bool isNewUser;

  const AuthResult({
    required this.user,
    required this.isNewUser,
  });

  @override
  List<Object?> get props => [user, isNewUser];
}
