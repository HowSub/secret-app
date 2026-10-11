import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret/features/chat/domain/repositories/chat_repository.dart';
import 'package:secret/features/chat/presentation/bloc/chat_event.dart';
import 'package:secret/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<SendMessage>((event, emit) {
      try {
        repository.sendMessage(event.senderId, event.text);
      } catch (e) {
        emit(ChatFailure(message: e.toString()));
      }
    });
  }
}
