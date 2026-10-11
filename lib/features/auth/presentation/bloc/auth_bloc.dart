import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<CreateUser>((event, emit) async {
      try {
        emit(AuthLoading());

        await repository.createUser(event.name, event.email, event.password);

        emit(AuthSuccessful());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignOutUser>((event, emit) async {
      try {
        await repository.signOut();
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignInUser>((event, emit) async {
      try {
        emit(AuthLoading());
        
        await repository.signIn(event.email, event.password);
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
  }
}
