// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/view-models/chats_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataSource extends Mock implements IDataSource {}

class MockUserService extends Mock implements IUserService {}

void main() {
  ChatsViewModel chatsViewModel;
  MockDataSource mockDataSource;
  MockUserService mockUserService;

  setUp(() {
    mockDataSource = MockDataSource();
    mockUserService = MockUserService();
    chatsViewModel = ChatsViewModel(mockDataSource, mockUserService);
  });

  final message = Message.fromJson({
    'from': '123',
    'to': '321',
    'content': 'this is a message',
    'timestamp': DateTime.parse("2022-01-01"),
    'id': '1'
  });

  final user = User(
      username: 'test', photoUrl: '', isActive: true, lastSeen: DateTime.now());

  test('initial chats return an empty list', () async {
    when(mockDataSource.findAllChats()).thenAnswer((_) async => []);
    expect(await chatsViewModel.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    when(mockDataSource.findAllChats()).thenAnswer((_) async => [Chat('123')]);
    when(mockUserService.fetch(any)).thenAnswer((_) async => user);
    final chats = await chatsViewModel.getChats();
    expect(chats, isNotEmpty);
  });

  test('creates a new chat when receiving a message for the first time',
      () async {
    when(mockDataSource.findChat(any)).thenAnswer((_) async => null);
    await chatsViewModel.receivedMessage(message);
    verify(mockDataSource.addChat(any)).called(1);
  });

  test('add new message to existing chat without creating a new one', () async {
    final chat = Chat('123');
    when(mockDataSource.findChat(any)).thenAnswer((_) async => chat);
    await chatsViewModel.receivedMessage(message);
    verifyNever(mockDataSource.addChat(chat));
    verify(mockDataSource.addMessage(any)).called(1);
  });
}
