abstract class AuthRepository {
  Future<void> createUser(String name, String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}