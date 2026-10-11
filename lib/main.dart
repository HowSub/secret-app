import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:secret/app.dart';
import 'package:secret/core/service/auth_service.dart';
import 'package:secret/features/auth/data/data_sources/auth_data_source.dart';
import 'package:secret/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret/features/chat/data/data_sources/chat_data_source.dart';
import 'package:secret/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:secret/features/chat/domain/repositories/chat_repository.dart';
import 'package:secret/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GetIt.I.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(dataSource: ChatDataSource()),
  );
  GetIt.I.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: AuthDataSource()),
  );
  GetIt.I.registerSingleton<AuthService>(AuthService());

  runApp(SecretApp());
}
