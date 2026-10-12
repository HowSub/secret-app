import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatDataSource {
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
  );

  final uid = FirebaseAuth.instance.currentUser?.uid;

  void sendMessage(String chatRoomId, String senderId, String text) async {
    try {
      await _db.ref('chats/$chatRoomId').push().set({
        'senderId': senderId,
        'text': text,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      throw '$e';
    }
  }
}
