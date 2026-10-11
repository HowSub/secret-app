import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final _auth = FirebaseAuth.instance;

  Future<void> createUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw '$e';
    }
  }
}
