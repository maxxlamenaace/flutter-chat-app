import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/services/receipt/receipt_service.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ReceiptService implements IReceiptService {
  final Connection _connection;
  final Rethinkdb _rethinkdb;

  final _controller = StreamController<Receipt>.broadcast();

  StreamSubscription? _changefeed;

  ReceiptService(this._rethinkdb, this._connection);

  @override
  dispose() {
    _controller.close();
    _changefeed?.cancel();
  }

  @override
  Stream<Receipt> getReceipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    Map record = await _rethinkdb
        .table('receipts')
        .insert(receipt.toJson())
        .run(_connection);

    return record['inserted'] == 1;
  }

  _startReceivingReceipts(User user) {
    _changefeed = _rethinkdb
        .table('receipts')
        .filter({'recipient': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) {
              return;
            } else {
              final receipt = Receipt.fromJson(feedData['new_val']);
              _controller.sink.add(receipt);
            }
          }).catchError((error) {
            print(error);
          }).onError((error, stackTrace) => print(error));
        });
  }
}
