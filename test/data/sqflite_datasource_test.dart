// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/data/sqflite_datasource.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqlite_api.dart';

class MockSQFLiteDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

void main() {
  SQFLiteDataSource sqfLiteDataSource;

  // Mocks
  MockSQFLiteDatabase mockSQFLiteDatabase;
  MockBatch mockBatch;

  setUp(() {
    mockSQFLiteDatabase = MockSQFLiteDatabase();
    mockBatch = MockBatch();

    sqfLiteDataSource = SQFLiteDataSource(mockSQFLiteDatabase);
  });

  final message = Message.fromJson({
    'from': '123',
    'to': '321',
    'content': 'this is a message',
    'timestamp': DateTime.parse('2022-01-01'),
    'id': '1'
  });

  test('should insert a chat in the database', () async {
    // arrange
    final chat = Chat('1234');
    when(mockSQFLiteDatabase.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    // act
    await sqfLiteDataSource.addChat(chat);

    // assert
    verify(mockSQFLiteDatabase.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should insert a message in the database', () async {
    // arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.SENT);
    when(mockSQFLiteDatabase.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    // act
    await sqfLiteDataSource.addMessage(localMessage);

    // assert
    verify(mockSQFLiteDatabase.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform a database query and return messages', () async {
    // arrange
    const chatId = '123';

    final messagesMap = [
      {
        'chat_id': chatId,
        'id': '321',
        'from': '123',
        'to': '321',
        'content': 'this is a message',
        'receipt': 'SENT',
        'timestamp': DateTime.parse('2022-01-01')
      }
    ];

    when(mockSQFLiteDatabase.query('messages',
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
        .thenAnswer((_) async => messagesMap);

    // act
    var messages = await sqfLiteDataSource.findMessages(chatId);

    // assert
    expect(messages.length, 1);
    expect(messages.first.chatId, chatId);
    verify(mockSQFLiteDatabase.query('messages',
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
        .called(1);
  });

  test('should update a message in the database', () async {
    // arrange
    final localMessage = LocalMessage('123', message, ReceiptStatus.SENT);

    when(mockSQFLiteDatabase.update('messages', localMessage.toMap(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    // act
    await sqfLiteDataSource.updateMessage(localMessage);

    // assert
    verify(mockSQFLiteDatabase.update('messages', localMessage.toMap(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform a batch delete of chat in the database', () async {
    // arrange
    final chatId = '111';
    when(mockSQFLiteDatabase.batch()).thenReturn(mockBatch);

    // act
    await sqfLiteDataSource.deleteChat(chatId);

    // assert
    verifyInOrder([
      mockSQFLiteDatabase.batch(),
      mockBatch.delete('messages',
          where: anyNamed('where'), whereArgs: anyNamed('whereArgs')),
      mockBatch.delete('chats',
          where: anyNamed('where'), whereArgs: anyNamed('whereArgs')),
      mockBatch.commit(noResult: true)
    ]);
  });
}
