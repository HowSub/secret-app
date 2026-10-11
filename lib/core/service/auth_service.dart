import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<User?>? _authSubscription;
  User? _user;
  String? _username;
  bool _isInitialized = false;

  AuthService() {
    _authSubscription = _auth.authStateChanges().listen((User? user) async {
      _user = user;

      if (_user != null) {
        try {
          final snapshot = await FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
          ).ref('users/${user?.uid}/username').get();
          _username = snapshot.value as String?;
        } catch (e) {
          _username = null;
        }
      } else {
        _username = null;
      }

      _isInitialized = true;
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;
  bool get hasUsername => _username != null && _username!.isNotEmpty;
}
