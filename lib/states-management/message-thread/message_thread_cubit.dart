import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view-models/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;

  MessageThreadCubit(this.viewModel) : super([]);

  Future<void> getMessages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}
