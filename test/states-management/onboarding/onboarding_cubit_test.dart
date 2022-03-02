// @dart=2.9

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/onboarding/onboarding_cubit.dart';
import 'package:chat_app/states-management/onboarding/onboarding_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserServiceMock extends Mock implements IUserService {}

void main() {
  IUserService userServiceMock;
  OnboardingCubit onboardingCubit;

  setUp(() {
    userServiceMock = UserServiceMock();
    onboardingCubit = OnboardingCubit(userServiceMock);
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
