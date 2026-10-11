abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatFailure extends ChatState  {
  String message;

  ChatFailure({required this.message});
}