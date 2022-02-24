import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/view-models/base_view_model.dart';
import 'package:chat_app/models/local_message.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;

  ChatsViewModel(this._dataSource) : super(_dataSource);

  Future<List<Chat>> getChats() async {
    return await _dataSource.findAllChats();
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.DELIVERED);

    await addMessage(localMessage);
  }
}
