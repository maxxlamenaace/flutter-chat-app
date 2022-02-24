import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'package:chat/src/services/user/user_service.dart';
import 'package:chat/src/models/user.dart';

class UserService implements IUserService {
  final Connection connection;
  final Rethinkdb rethinkdb;

  UserService(this.rethinkdb, this.connection);

  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    if (user.id != null) {
      data['id'] = user.id;
    }

    final result = await rethinkdb.table('users').insert(
        data, {'conflict': 'update', 'return_changes': true}).run(connection);

    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    await rethinkdb.table('users').update({
      'id': user.id,
      'is_active': false,
      'last_seen': DateTime.now()
    }).run(connection);

    connection.close();
  }

  @override
  Future<List<User>> getOnlineUsers() async {
    Cursor users = await rethinkdb
        .table('users')
        .filter({'is_active': true}).run(connection);

    final usersList = await users.toList();
    return usersList.map((item) => User.fromJson(item)).toList();
  }
}
