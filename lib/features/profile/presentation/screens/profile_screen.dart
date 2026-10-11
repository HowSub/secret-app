import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret/features/profile/presentation/widgets/profile_alert_dialog.dart';
import 'package:secret/features/profile/presentation/widgets/profile_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(GetIt.I<AuthRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Builder(
              builder: (newContext) {
                return IconButton(
                  onPressed: () {
                    showDialog(
                      context: newContext,
                      builder: (dialogContext) {
                        return ProfileAlertDialog(parentContext: newContext);
                      },
                    );
                  },
                  icon: Icon(Icons.exit_to_app),
                );
              },
            ),
          ],
        ),
        body: ProfileSettings(),
      ),
    );
  }
}
