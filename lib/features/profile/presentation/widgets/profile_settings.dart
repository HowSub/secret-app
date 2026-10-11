import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secret/core/service/auth_service.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();

    final userDisplayName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Ошибка';
    final username = authService.username;
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.black,
            child: Text(
              userDisplayName[0],
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userDisplayName,
            style: TextStyle(fontSize: 30, fontWeight: .w500),
          ),
          Text('@$username'),
        ],
      ),
    );
  }
}
