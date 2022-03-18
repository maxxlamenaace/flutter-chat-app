import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/online-users/online_users_cubit.dart';
import 'package:chat_app/states-management/home/online-users/online_users_state.dart';
import 'package:chat_app/ui/pages/home/home_router.dart';
import 'package:chat_app/ui/widgets/home/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  final User activeUser;
  final IHomeRouter router;

  const ActiveUsers(this.activeUser, this.router);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  _listItem(User user) => ListTile(
      leading: Avatar(imageUrl: user.photoUrl, isOnline: user.isActive),
      title: Text(user.username,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold)));

  _buildList(List<User> users) => ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (BuildContext context, index) => GestureDetector(
          child: _listItem(users[index]),
          onTap: () => {
                widget.router.onShowMessageThread(
                    context, users[index], widget.activeUser,
                    chatId: users[index].id)
              }),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: users.length);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnlineUsersCubit, OnlineUsersState>(builder: (_, state) {
      if (state is OnlineUsersLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is OnlineUsersSuccess) {
        return _buildList(state.onlineUsers);
      } else {
        return Container();
      }
    });
  }
}
