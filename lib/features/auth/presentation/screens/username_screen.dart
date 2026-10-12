import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secret/core/service/auth_service.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  bool _isLoading = false;
  bool? _isUnique;

  void _onTextChanged(String text) {
    final username = text.trim().toLowerCase();

    setState(() {
      _isUnique = null;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final regExp = RegExp('^[a-zA-Z0-9_]+\$');

    if (username.length < 3) return;
    if (!regExp.hasMatch(username)) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (username.isNotEmpty) {
        _checkUniqueness(username);
      }
    });
  }

  void _checkUniqueness(String username) async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
      ).ref('usernames/$username').get();

      setState(() {
        _isUnique = snapshot.value == null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Text(
                'Enter your username',
                style: TextStyle(fontSize: 30, fontWeight: .w600),
              ),
              const SizedBox(height: 40),
              TextField(
                onChanged: _onTextChanged,
                controller: _controller,
                decoration: InputDecoration(
                  prefixText: '@',
                  suffixIcon: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : _isUnique == null
                      ? null
                      : _isUnique!
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
                  hintText: 'username',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_isUnique != null)
                Text(
                  _isUnique!
                      ? 'This username is available'
                      : 'This username is not available',
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _isUnique == true && !_isLoading
                      ? () async {
                          final username = _controller.text.trim();
                          try {
                            await GetIt.I<AuthService>().saveUsername(username);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Something went wrong')),
                            );
                          }
                        }
                      : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
