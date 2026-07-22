import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? username;
  final String? email;
  final bool isAnonymous;

  const User({
    required this.id,
    this.username,
    this.email,
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [id, username, email, isAnonymous];
}
