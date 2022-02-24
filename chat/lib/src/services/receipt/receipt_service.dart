import 'package:chat/src/models/user.dart';

import '../../models/receipt.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> getReceipts(User user);
  void dispose();
}
