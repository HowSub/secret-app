import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret/features/auth/presentation/bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isShow = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => AuthBloc(GetIt.I<AuthRepository>()),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 34, fontWeight: .w600),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Empty input';
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name...',
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
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Empty input';
                      }
                      final regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');
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
                              final _name = _nameController.text.trim();
                              final _email = _emailController.text.trim();
                              final _password = _passwordController.text.trim();

                              newContext.read<AuthBloc>().add(
                                CreateUser(
                                  name: _name,
                                  email: _email,
                                  password: _password,
                                ),
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
                                'SignUp',
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
                    child: Text('Already have an account? Sign In'),
                    onTap: () {
                      context.go('/');
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
