import 'package:secret/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.email,
    required super.name,
    required super.password,
  });
}
