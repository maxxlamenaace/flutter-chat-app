import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/chats/chats_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_state.dart';
import 'package:chat_app/states-management/message/message_bloc.dart';
import 'package:chat_app/ui/widgets/home/active-users/active_users.dart';
import 'package:chat_app/ui/widgets/home/avatar.dart';
import 'package:chat_app/ui/widgets/home/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<ChatsCubit>().getChats();
    context.read<OnlineUsersCubit>().getActiveUsers();

    final user = User.fromJson({
      "id": "90e008e7-1f72-4d22-9d94-9d3149c6ad60",
      "username": "Maxime",
      "is_active": true,
      "photo_url": "",
      "last_seen": DateTime.now()
    });

    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Container(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      const Avatar(
                        imageUrl:
                            "https://avatars.dicebear.com/api/human/sdlhf.svg",
                        isOnline: true,
                      ),
                      Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text('Jess',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                        Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text('online',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(fontSize: 14)))
                      ])
                    ],
                  )),
              bottom: TabBar(
                  indicatorPadding: const EdgeInsets.only(top: 10, bottom: 10),
                  tabs: [
                    Tab(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Align(
                          alignment: Alignment.center, child: Text('Messages')),
                    )),
                    Tab(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: Align(
                              alignment: Alignment.center,
                              child: BlocBuilder<OnlineUsersCubit,
                                      OnlineUsersState>(
                                  builder: (_, state) => state
                                          is OnlineUsersSuccess
                                      ? Text(
                                          'Active users (${state.onlineUsers.length})')
                                      : const Text('Active users (0)')),
                            )))
                  ])),
          body: TabBarView(children: [
            Container(child: Chats()),
            Container(child: ActiveUsers())
          ]),
        ));
  }
}
