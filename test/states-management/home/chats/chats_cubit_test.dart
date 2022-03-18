// @dart=2.9

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/states-management/home/chats/chats_cubit.dart';
import 'package:chat_app/view-models/chats_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChatsViewModel extends Mock implements ChatsViewModel {}

void main() {
  ChatsCubit chatsCubit;
  ChatsViewModel mockChatsViewModel;

  setUp(() {
    mockChatsViewModel = MockChatsViewModel();
    chatsCubit = ChatsCubit(mockChatsViewModel);
  });

  tearDown(() {
    chatsCubit.close();
  });

  test('should emit chats', () {
    final chat = Chat("id");
    when(mockChatsViewModel.getChats()).thenAnswer((_) async => [chat]);

    expectLater(chatsCubit.stream, emits([chat]));

    chatsCubit.getChats();
  });
}
