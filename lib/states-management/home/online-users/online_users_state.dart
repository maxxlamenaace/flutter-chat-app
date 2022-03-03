import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class OnlineUsersState extends Equatable {}

class OnlineUsersInitial extends OnlineUsersState {
  @override
  List<Object?> get props => [];
}

class OnlineUsersLoading extends OnlineUsersState {
  @override
  List<Object?> get props => [];
}

class OnlineUsersSuccess extends OnlineUsersState {
  final List<User> onlineUsers;

  OnlineUsersSuccess(this.onlineUsers);

  @override
  List<Object?> get props => [onlineUsers];
}
