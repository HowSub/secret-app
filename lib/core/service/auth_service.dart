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

      if (user != null) {
        try {
          final snapshot =
              await FirebaseDatabase.instanceFor(
                    app: Firebase.app(),
                    databaseURL:
                        'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
                  )
                  .ref('users/${user.uid}/username')
                  .get()
                  .timeout(
                    const Duration(seconds: 3),
                  );
          _username = snapshot.value as String?;
        } catch (e) {
          print(e);
          _username = null;
        }
      } else {
        _username = null;
      }

      _isInitialized = true;
      notifyListeners();
    });
  }

Future<void> saveUsername(String originalUsername) async {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return;

  final lowercaseUsername = originalUsername.toLowerCase(); 

  final db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
  );

  await db.ref().update({
    'users/$uid/username': originalUsername,
    'usernames/$lowercaseUsername': uid,        
  });

  _username = originalUsername;
  notifyListeners(); 
}

  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;
  bool get hasUsername => _username != null && _username!.isNotEmpty;
  String? get username => _username;
}
