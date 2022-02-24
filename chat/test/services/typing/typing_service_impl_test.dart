// @dart=2.9

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing/typing_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import '../../helpers.dart';

void main() {
  Rethinkdb rethinkdb = Rethinkdb();
  Connection connection;
  TypingService typingService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    typingService = TypingService(rethinkdb, connection);
  });

  tearDown(() async {
    typingService.dispose();
    cleanDb(rethinkdb, connection);
  });

  final user1 = User.fromJson(
      {'id': '1', 'is_active': true, 'last_seen': DateTime.now()});

  final user2 = User.fromJson(
      {'id': '2', 'is_active': true, 'last_seen': DateTime.now()});

  test('sent typing notification successfully', () async {
    TypingEvent typingEvent =
        TypingEvent(from: user2.id, to: user1.id, event: Typing.START);

    final result =
        await typingService.send(typingEvent: typingEvent, to: user1);

    expect(result, true);
  });

  test('successfully subscribe and receive typing events', () async {
    TypingEvent typingEvent1 =
        TypingEvent(from: user1.id, to: user2.id, event: Typing.START);

    TypingEvent typingEvent2 =
        TypingEvent(from: user1.id, to: user2.id, event: Typing.STOP);

    await typingService.send(typingEvent: typingEvent1, to: user2);
    await typingService.send(typingEvent: typingEvent2, to: user2);

    typingService
        .subscribe(user2, [user1.id]).listen(expectAsync1((typingEvent) {
      expect(typingEvent.from, user1.id);
    }, count: 2));
  });
}
