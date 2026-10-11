abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  String senderId;
  String text;

  SendMessage({required this.senderId, required this.text});
}