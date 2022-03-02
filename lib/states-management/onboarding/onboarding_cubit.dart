import 'dart:io';

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/onboarding/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;

  OnboardingCubit(this._userService) : super(OnboardingInitial());

  Future<void> connect(String username, String profileImage) async {
    emit(Loading());

    final user = User(
        username: username,
        photoUrl: profileImage,
        isActive: true,
        lastSeen: DateTime.now());

    final createdUser = await _userService.connect(user);

    emit(OnboardingSuccess(createdUser));
  }
}
