import 'package:chat_app/models/chat.dart';
import 'package:chat_app/view-models/chats_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel chatsViewModel;

  ChatsCubit(this.chatsViewModel) : super([]);

  Future<void> getChats() async {
    final chats = await chatsViewModel.getChats();
    emit(chats);
  }
}
