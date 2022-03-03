import 'package:chat_app/states-management/home/home_cubit.dart';
import 'package:chat_app/states-management/home/home_state.dart';
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

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getActiveUsers();
  }

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
                              child: BlocBuilder<HomeCubit, HomeState>(
                                  builder: (_, state) => state is HomeSuccess
                                      ? Text(
                                          'Active users (${state.onlineUsers.length})')
                                      : Text('Active users (0)')),
                            )))
                  ])),
          body: TabBarView(children: [
            Container(child: Chats()),
            Container(child: ActiveUsers())
          ]),
        ));
  }
}
