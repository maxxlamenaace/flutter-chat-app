// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/cache/local_cache.dart';
import 'package:chat_app/states-management/onboarding/onboarding_cubit.dart';
import 'package:chat_app/states-management/onboarding/onboarding_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements IUserService {}

class LocalCacheMock extends Mock implements ILocalCache {}

void main() {
  IUserService userServiceMock;
  ILocalCache localCacheMock;
  OnboardingCubit onboardingCubit;

  setUp(() {
    userServiceMock = UserServiceMock();
    onboardingCubit = OnboardingCubit(userServiceMock, localCacheMock);
  });

  tearDown(() {
    onboardingCubit.close();
  });

  final user = User(
      username: 'test', photoUrl: '', isActive: true, lastSeen: DateTime.now());

  test('should emit onboarding connect state when user begin session', () {
    when(userServiceMock.connect(any)).thenAnswer((_) async => user);

    expectLater(onboardingCubit.stream,
        emitsInOrder([Loading(), OnboardingSuccess(user)]));

    onboardingCubit.connect('username', 'photoUrl');
  });
}
