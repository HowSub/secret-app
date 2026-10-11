abstract class AuthEvent {}

class CreateUser extends AuthEvent {
  String name;
  String email;
  String password;

  CreateUser({required this.name, required this.email, required this.password});
}

class SignOutUser extends AuthEvent {}

class SignInUser extends AuthEvent {
  String email;
  String password;

  SignInUser({required this.email, required this.password});
}
