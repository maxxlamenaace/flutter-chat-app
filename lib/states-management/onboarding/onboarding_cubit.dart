import 'dart:io';

import 'package:chat/chat.dart';
import 'package:chat_app/cache/local_cache.dart';
import 'package:chat_app/states-management/onboarding/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ILocalCache _localCache;

  OnboardingCubit(this._userService, this._localCache)
      : super(OnboardingInitial());

  Future<void> connect(String username, String profileImage) async {
    emit(Loading());

    final user = User(
        username: username,
        photoUrl: profileImage,
        isActive: true,
        lastSeen: DateTime.now());

    final createdUser = await _userService.connect(user);

    final createdUserAsJson = {
      'username': createdUser.username,
      'photo_url': createdUser.photoUrl,
      'is_active': createdUser.isActive,
      'id': createdUser.id
    };

    _localCache.save('user_cached', createdUserAsJson);

    emit(OnboardingSuccess(createdUser));
  }
}
