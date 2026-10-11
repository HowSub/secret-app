abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccessful extends AuthState {}

class AuthFailure extends AuthState {
  String message;

  AuthFailure({required this.message});
}