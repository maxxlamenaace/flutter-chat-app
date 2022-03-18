import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view-models/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final IDataSource _dataSource;

  String _chatId = '';
  int otherMessages = 0;

  ChatViewModel(this._dataSource) : super(_dataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) {
      _chatId = chatId;
    }

    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.SENT);

    if (_chatId.isNotEmpty) {
      return await _dataSource.addMessage(localMessage);
    } else {
      _chatId = localMessage.chatId;
      await super.addMessage(localMessage);
    }
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.DELIVERED);

    if (localMessage.chatId != _chatId) {
      otherMessages++;
    }

    await super.addMessage(localMessage);
  }
}
