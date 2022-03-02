import 'package:chat/chat.dart';
import 'package:chat_app/states-management/onboarding/onboarding_cubit.dart';
import 'package:chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class CompositionRoot {
  static late RethinkDb _rethinkDb;
  static late Connection _connection;
  static late IUserService _userService;

  static configure() async {
    _rethinkDb = RethinkDb();
    _connection = await _rethinkDb.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_rethinkDb, _connection);
  }

  static Widget composeOnboardingUI() {
    OnboardingCubit onboardingCubit = OnboardingCubit(_userService);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onboardingCubit)
    ], child: const Onboarding());
  }
}
