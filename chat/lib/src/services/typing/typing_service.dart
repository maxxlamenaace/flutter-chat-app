import 'package:chat/src/models/typing_event.dart';

import '../../models/user.dart';

abstract class ITypingService {
  Future<bool> send({required TypingEvent typingEvent});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
