import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;

  HomeCubit(this._userService) : super(HomeInitial());

  Future<void> getActiveUsers() async {
    emit(HomeLoading());
    final users = await _userService.getOnlineUsers();
    emit(HomeSuccess(users));
  }
}
