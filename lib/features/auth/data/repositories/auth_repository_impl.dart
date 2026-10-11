import 'package:secret/features/auth/data/data_sources/auth_data_source.dart';
import 'package:secret/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource _dataSource;

  AuthRepositoryImpl({required this._dataSource});

  @override
  Future<void> createUser(String name, String email, String password) async {
    await _dataSource.createUser(name, email, password);
  }

  Future<void> signIn(String email, String password) async {
    await _dataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
}