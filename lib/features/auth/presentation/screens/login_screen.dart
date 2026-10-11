import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShow = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(GetIt.I<AuthRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(fontSize: 34, fontWeight: .w600),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Empty input';
                      }
                      final regExp = RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d).{6,}$',
                      );
                      if (!regExp.hasMatch(value)) {
                        return 'Enter correct email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter email...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Empty input';
                      }
                      final regExp = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
                      );
                      if (!regExp.hasMatch(value)) {
                        return 'Password must have 8 symbols and special symbols';
                      }
                      return null;
                    },
                    obscureText: !isShow,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                        icon: isShow
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                      hintText: 'Enter password...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (newContext) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final _email = _emailController.text.trim();
                              final _password = _passwordController.text.trim();

                              newContext.read<AuthBloc>().add(
                                SignInUser(email: _email, password: _password),
                              );
                            }
                          },
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              }
                              return const Text(
                                'SignIn',
                                style: TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: Text('Don\'t have an account? Sign Up'),
                    onTap: () {
                      context.go('/register');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
