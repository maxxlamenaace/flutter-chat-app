import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/online-users/online_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  final IUserService _userService;

  OnlineUsersCubit(this._userService) : super(OnlineUsersInitial());

  Future<void> getActiveUsers() async {
    emit(OnlineUsersLoading());
    final users = await _userService.getOnlineUsers();
    emit(OnlineUsersSuccess(users));
  }
}
