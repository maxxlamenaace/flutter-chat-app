// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MessageServiceMock extends Mock implements IMessageService {}

void main() {
  MessageBloc messageBloc;
  IMessageService messageServiceMock;
  User user;

  setUp(() {
    messageServiceMock = MessageServiceMock();
    user = User(
        username: 'test',
        photoUrl: '',
        isActive: true,
        lastSeen: DateTime.now());

    messageBloc = MessageBloc(messageServiceMock);
  });

  tearDown(() => messageBloc.close());

  final message = Message(
      from: '123',
      to: '321',
      content: 'this is a message',
      timestamp: DateTime.now());

  test('should emit initial state only without subscription', () {
    expect(messageBloc.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () {
    when(messageServiceMock.send(message)).thenAnswer((_) async => true);
    messageBloc.add(MessageEvent.onMessageSent(message));
    expectLater(messageBloc.stream, emits(MessageState.sent(message)));
  });

  test('should emit received messages from service', () {
    when(messageServiceMock.getMessages(activeUser: anyNamed('activeUser')))
        .thenAnswer((_) => Stream.fromIterable([message]));

    messageBloc.add(MessageEvent.onSubscribed(user));
    expectLater(
        messageBloc.stream, emitsInOrder([MessageReceivedSuccess(message)]));
  });
}
