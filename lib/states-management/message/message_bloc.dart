import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  StreamSubscription? _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial()) {
    on<Subscribed>(_onSubscribedEvent);
    on<MessageSent>(_onMessageSentEvent);
    on<_MessageReceived>(_onMessageReceivedEvent);
  }

  void _onSubscribedEvent(Subscribed event, Emitter<MessageState> emit) async {
    await _subscription?.cancel();
    _subscription = _messageService
        .getMessages(activeUser: event.user)
        .listen((message) => add(_MessageReceived(message)));
  }

  void _onMessageReceivedEvent(
      _MessageReceived event, Emitter<MessageState> emit) {
    emit(MessageState.received(event.message));
  }

  void _onMessageSentEvent(
      MessageSent event, Emitter<MessageState> emit) async {
    await _messageService.send(event.message);
    emit(MessageState.sent(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
