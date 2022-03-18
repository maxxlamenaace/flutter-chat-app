import 'package:chat/chat.dart';
import 'package:chat_app/cache/local_cache.dart';
import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/data/factories/db_factory.dart';
import 'package:chat_app/data/sqflite_datasource.dart';
import 'package:chat_app/states-management/home/chats/chats_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_cubit.dart';
import 'package:chat_app/states-management/message/message_bloc.dart';
import 'package:chat_app/states-management/onboarding/onboarding_cubit.dart';
import 'package:chat_app/states-management/typing/typing_notification_bloc.dart';
import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:chat_app/ui/pages/onboarding/onboarding_router.dart';
import 'package:chat_app/view-models/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class CompositionRoot {
  static late RethinkDb _rethinkDb;
  static late Connection _connection;
  static late IUserService _userService;
  static late IMessageService _messageService;
  static late Database _database;
  static late IDataSource _dataSource;
  static late ILocalCache _localCache;
  static late MessageBloc _messageBloc;
  static late ITypingService _typingService;

  static configure() async {
    _rethinkDb = RethinkDb();
    _connection = await _rethinkDb.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_rethinkDb, _connection);
    _messageService = MessageService(_rethinkDb, _connection);
    _database = await LocalDatabaseFactory().createDatabase();
    _dataSource = SQFLiteDataSource(_database);
    _typingService = TypingService(_rethinkDb, _connection, _userService);

    /* await _rethinkDb.table('messages').delete().run(_connection);
    await _database.delete('messages');
    await _database.delete('chats'); */

    _localCache = LocalCache(await SharedPreferences.getInstance());
    _messageBloc = MessageBloc(_messageService);
  }

  static Widget start() {
    final user = _localCache.fetch('user_cached');

    if (user.isNotEmpty) {
      user['last_seen'] = DateTime.now();
      return composeHomeUI(User.fromJson(user));
    } else {
      return composeOnboardingUI();
    }
  }

  static Widget composeOnboardingUI() {
    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, _localCache);

    IOnboardingRouter router = OnboardingRouter(composeHomeUI);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onboardingCubit)
    ], child: Onboarding(router));
  }

  static Widget composeHomeUI(User user) {
    OnlineUsersCubit onlineUsersCubit =
        OnlineUsersCubit(_userService, _localCache);
    ChatsViewModel chatsViewModel = ChatsViewModel(_dataSource, _userService);
    ChatsCubit chatsCubit = ChatsCubit(chatsViewModel);
    TypingNotificationBloc typingNotificationBloc =
        TypingNotificationBloc(_typingService);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onlineUsersCubit),
      BlocProvider(create: (BuildContext context) => _messageBloc),
      BlocProvider(create: (BuildContext context) => chatsCubit),
      BlocProvider(create: (BuildContext context) => typingNotificationBloc)
    ], child: Home(user));
  }
}
