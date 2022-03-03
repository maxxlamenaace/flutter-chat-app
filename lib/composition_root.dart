import 'package:chat/chat.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/data/factories/db_factory.dart';
import 'package:chat_app/data/sqflite_datasource.dart';
import 'package:chat_app/states-management/home/chats/chats_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_cubit.dart';
import 'package:chat_app/states-management/message/message_bloc.dart';
import 'package:chat_app/states-management/onboarding/onboarding_cubit.dart';
import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:chat_app/view-models/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:sqflite/sqlite_api.dart';

class CompositionRoot {
  static late RethinkDb _rethinkDb;
  static late Connection _connection;
  static late IUserService _userService;
  static late IMessageService _messageService;
  static late Database _database;
  static late IDataSource _dataSource;

  static configure() async {
    _rethinkDb = RethinkDb();
    _connection = await _rethinkDb.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_rethinkDb, _connection);
    _messageService = MessageService(_rethinkDb, _connection);
    _database = await LocalDatabaseFactory().createDatabase();
    _dataSource = SQFLiteDataSource(_database);
  }

  static Widget composeOnboardingUI() {
    OnboardingCubit onboardingCubit = OnboardingCubit(_userService);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onboardingCubit)
    ], child: const Onboarding());
  }

  static Widget composeHomeUI() {
    OnlineUsersCubit onlineUsersCubit = OnlineUsersCubit(_userService);
    MessageBloc messageBloc = MessageBloc(_messageService);
    ChatsViewModel chatsViewModel = ChatsViewModel(_dataSource, _userService);
    ChatsCubit chatsCubit = ChatsCubit(chatsViewModel);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onlineUsersCubit),
      BlocProvider(create: (BuildContext context) => messageBloc),
      BlocProvider(create: (BuildContext context) => chatsCubit)
    ], child: const Home());
  }
}
