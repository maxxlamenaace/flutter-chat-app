// @dart=2.9

import 'package:chat/src/services/encryption/encryption_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';

import '../../helpers.dart';

void main() {
  RethinkDb rethinkdb = RethinkDb();
  Connection connection;
  MessageService messageService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    final encryptionService =
        EncryptionService(Encrypter(AES(Key.fromLength(32))));

    await createDb(rethinkdb, connection);
    messageService = MessageService(rethinkdb, connection, encryptionService);
  });

  tearDown(() async {
    messageService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  final user1 = User.fromJson(
      {'id': '1', 'is_active': true, 'last_seen': DateTime.now()});

  final user2 = User.fromJson(
      {'id': '2', 'is_active': true, 'last_seen': DateTime.now()});

  test('send a message successfully', () async {
    Message message = Message(
        from: user1.id, to: '1234', timestamp: DateTime.now(), content: 'test');

    final result = await messageService.send(message);

    expect(result, true);
  });

  test('successfully subscribe and receive message', () async {
    const text = 'this is a message';
    Message message1 = Message(
        from: user1.id, to: user2.id, timestamp: DateTime.now(), content: text);

    Message message2 = Message(
        from: user1.id, to: user2.id, timestamp: DateTime.now(), content: text);

    await messageService.send(message1);
    await messageService.send(message2).whenComplete(() => messageService
        .getMessages(activeUser: user2)
        .listen(expectAsync1((message) {
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
          expect(message.content, text);
        }, count: 2)));
  });
}
