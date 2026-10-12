import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthDataSource {
  final _auth = FirebaseAuth.instance;

  Future<void> createUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      final _uid = userCredential.user?.uid;

      final _ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
      ).ref('users/$_uid');

      await _ref.set({
        'name': name,
        'email': email,
      });
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
