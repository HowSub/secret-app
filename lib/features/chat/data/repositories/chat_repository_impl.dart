import 'package:secret/features/chat/data/data_sources/chat_data_source.dart';
import 'package:secret/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {

  final ChatDataSource _dataSource;

  ChatRepositoryImpl({required this._dataSource});

  @override
  void sendMessage(String senderId, String text) {
    _dataSource.sendMessage(senderId, text);
  }
}