import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final username = FirebaseAuth.instance.currentUser?.displayName ?? 'Ошибка';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.black,
            child: Text(
              username[0],
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
          const SizedBox(height: 10),
          Text(username, style: TextStyle(fontSize: 30, fontWeight: .w500)),
        ],
      ),
    );
  }
}
