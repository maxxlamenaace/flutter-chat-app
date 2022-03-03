// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/online-users/online_users_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements IUserService {}

void main() {
  IUserService userServiceMock;
  OnlineUsersCubit onlineUsersCubit;

  setUp(() {
    userServiceMock = UserServiceMock();
    onlineUsersCubit = OnlineUsersCubit(userServiceMock);
  });

  tearDown(() {
    onlineUsersCubit.close();
  });

  final user = User(
      username: 'test', photoUrl: '', isActive: true, lastSeen: DateTime.now());

  test('should emit online users from service', () {
    when(userServiceMock.getOnlineUsers()).thenAnswer((_) async => [user]);

    expectLater(
        onlineUsersCubit.stream,
        emitsInOrder([
          OnlineUsersLoading(),
          OnlineUsersSuccess([user])
        ]));

    onlineUsersCubit.getActiveUsers();
  });
}
