// @dart=2.9

import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../../helpers.dart';

void main() {
  RethinkDb rethinkdb = RethinkDb();
  Connection connection;
  ReceiptService receiptService;

  setUp(() async {
    connection = await rethinkdb.connect(host: "127.0.0.1", port: 28015);
    await createDb(rethinkdb, connection);
    receiptService = ReceiptService(rethinkdb, connection);
  });

  tearDown(() async {
    receiptService.dispose();
    await cleanDb(rethinkdb, connection);
  });

  test('send receipt successfully', () async {
    Receipt receipt = Receipt(
        recipient: '123',
        messageId: '1234',
        status: ReceiptStatus.DELIVERED,
        timestamp: DateTime.now());

    final result = await receiptService.send(receipt);
    expect(result, true);
  });

  test('successfully subscribe and receive receipts', () async {
    User user = User.fromJson({
      'id': '1234',
      'is_active': true,
      'last_seen': DateTime.now(),
    });

    Receipt receipt1 = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.DELIVERED,
        timestamp: DateTime.now());

    Receipt receipt2 = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.READ,
        timestamp: DateTime.now());

    await receiptService.send(receipt1);
    await receiptService.send(receipt2);

    receiptService.getReceipts(user).listen(expectAsync1((receipt) {
          expect(receipt.recipient, user.id);
        }, count: 2));
  });
}
