import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatDataSource {
  final DatabaseReference _ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref('messages/chat_room_1');

  final uid = FirebaseAuth.instance.currentUser?.uid;

  void sendMessage(String senderId, String text) async {
    try {
      await _ref.push().set({
        'senderId': senderId,
        'text': text,
        'timestamp': ServerValue.timestamp, 
      });
    } catch(e) {
      throw '$e';
    }
  }
}
