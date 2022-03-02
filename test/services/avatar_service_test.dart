// @dart=2.9
import 'package:chat_app/services/avatar_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AvatarService avatarService = AvatarService();

  test('should render random uri path', () async {
    final url1 = avatarService.getRandomAvatarUrl();
    final url2 = avatarService.getRandomAvatarUrl();

    expect(url1, isNot(equals(url2)));
  });
}
