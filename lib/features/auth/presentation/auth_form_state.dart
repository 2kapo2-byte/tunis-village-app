import 'package:flutter/foundation.dart';

@immutable
class AuthFormState {
  const AuthFormState({this.email = '', this.password = '', this.confirmPassword = ''});

  final String email;
  final String password;
  final String confirmPassword;

  bool get isEmailValid => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  bool get isPasswordValid => password.length >= 6;
  bool get passwordsMatch => password == confirmPassword;
}
