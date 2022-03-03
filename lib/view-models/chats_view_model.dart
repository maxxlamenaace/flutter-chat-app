import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/view-models/base_view_model.dart';
import 'package:chat_app/models/local_message.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;
  IUserService _userService;

  ChatsViewModel(this._dataSource, this._userService) : super(_dataSource);

  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });

    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.DELIVERED);

    await addMessage(localMessage);
  }
}
