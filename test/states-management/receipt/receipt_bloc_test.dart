// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/receipt/receipt_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ReceiptServiceMock extends Mock implements IReceiptService {}

void main() {
  ReceiptBloc receiptBloc;
  IReceiptService receiptServiceMock;
  User user;

  setUp(() {
    receiptServiceMock = ReceiptServiceMock();
    user = User(
        username: 'test',
        photoUrl: '',
        isActive: true,
        lastSeen: DateTime.now());

    receiptBloc = ReceiptBloc(receiptServiceMock);
  });

  tearDown(() => receiptBloc.close());

  final receipt = Receipt(
      recipient: '123',
      messageId: '1',
      status: ReceiptStatus.SENT,
      timestamp: DateTime.now());

  test('should emit initial state only without subscription', () {
    expect(receiptBloc.state, ReceiptInitial());
  });

  test('should emit receipt sent state when message is sent', () {
    when(receiptServiceMock.send(receipt)).thenAnswer((_) async => true);
    receiptBloc.add(ReceiptEvent.onReceiptSent(receipt));
    expectLater(receiptBloc.stream, emits(ReceiptState.sent(receipt)));
  });

  test('should emit received receipts from service', () {
    when(receiptServiceMock.getReceipts(any))
        .thenAnswer((_) => Stream.fromIterable([receipt]));

    receiptBloc.add(ReceiptEvent.onSubscribed(user));
    expectLater(
        receiptBloc.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
  });
}
