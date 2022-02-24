// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/view-models/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataSource extends Mock implements IDataSource {}

void main() {
  ChatViewModel chatViewModel;
  MockDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDataSource();
    chatViewModel = ChatViewModel(mockDataSource);
  });

  final message = Message.fromJson({
    'from': '123',
    'to': '321',
    'content': 'this is a message',
    'timestamp': DateTime.parse("2022-01-01"),
    'id': '1'
  });

  final chat = Chat('123');
  final localMessage = LocalMessage(chat.id, message, ReceiptStatus.DELIVERED);

  test('initial messages return an empty list', () async {
    when(mockDataSource.findMessages(any)).thenAnswer((_) async => []);
    expect(await chatViewModel.getMessages('123'), isEmpty);
  });

  test('returns list of messages from local datasource', () async {
    // arrange
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.DELIVERED);

    when(mockDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);

    // act
    final messages = await chatViewModel.getMessages(chat.id);

    // assert
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, chat.id);
  });

  test('creates a new chat when sending first message', () async {
    when(mockDataSource.findChat(any)).thenAnswer((_) async => null);
    await chatViewModel.sentMessage(message);
    verify(mockDataSource.addChat(any)).called(1);
  });

  test('adds new sent message to the chat', () async {
    // arrange
    when(mockDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);

    // act
    await chatViewModel.getMessages(chat.id);
    await chatViewModel.sentMessage(message);

    // assert
    verifyNever(mockDataSource.addChat(any));
    verify(mockDataSource.addMessage(any)).called(1);
  });

  test('adds new received message to the chat', () async {
    // arrange
    when(mockDataSource.findMessages(any))
        .thenAnswer((_) async => [localMessage]);

    when(mockDataSource.findChat(chat.id)).thenAnswer((_) async => chat);

    // act
    await chatViewModel.receivedMessage(message);

    // assert
    verifyNever(mockDataSource.addChat(any));
    verify(mockDataSource.addMessage(any)).called(1);
  });

  test('creates a new chat when received message is not apart of this chat',
      () async {
    // arrange
    when(mockDataSource.findMessages(any))
        .thenAnswer((_) async => [localMessage]);

    when(mockDataSource.findChat(any)).thenAnswer((_) async => null);

    // act
    await chatViewModel.getMessages('1234');
    await chatViewModel.receivedMessage(message);

    // assert
    verify(mockDataSource.addChat(any)).called(1);
    verify(mockDataSource.addMessage(any)).called(1);
    expect(chatViewModel.otherMessages, 1);
  });
}
