// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/typing/typing_notification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class TypingServiceMock extends Mock implements ITypingService {}

void main() {
  TypingNotificationBloc typingNotificationBloc;
  ITypingService typingServiceMock;
  User user;

  setUp(() {
    typingServiceMock = TypingServiceMock();
    user = User(
        username: 'test',
        photoUrl: '',
        isActive: true,
        lastSeen: DateTime.now());

    typingNotificationBloc = TypingNotificationBloc(typingServiceMock);
  });

  tearDown(() => typingNotificationBloc.close());

  final typingEvent = TypingEvent(from: '123', to: '321', event: Typing.START);

  test('should emit initial state only without subscription', () {
    expect(typingNotificationBloc.state, TypingInitial());
  });

  test('should emit initial state when no users to subscribe to', () {
    typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(user));
    expectLater(typingNotificationBloc.stream,
        emits(TypingNotificationState.initial()));
  });

  test(
      'should emit typing notification sent state when typing notification is sent',
      () {
    when(typingServiceMock.send(typingEvent: typingEvent))
        .thenAnswer((_) async => true);
    typingNotificationBloc
        .add(TypingNotificationEvent.onTypingNotificationSent(typingEvent));
    expectLater(
        typingNotificationBloc.stream, emits(TypingNotificationState.sent()));
  });

  test('should emit received typing notifications from service', () {
    final List<String> usersToSubscribe = ['123'];
    when(typingServiceMock.subscribe(user, usersToSubscribe))
        .thenAnswer((_) => Stream.fromIterable([typingEvent]));

    typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(user,
        usersWithChat: usersToSubscribe));
    expectLater(typingNotificationBloc.stream,
        emitsInOrder([TypingNotificationState.received(typingEvent)]));
  });
}
