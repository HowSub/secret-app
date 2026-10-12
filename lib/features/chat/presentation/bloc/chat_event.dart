abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  String chatRoomId;
  String senderId;
  String text;

  SendMessage({
    required this.chatRoomId,
    required this.senderId,
    required this.text,
  });
}
