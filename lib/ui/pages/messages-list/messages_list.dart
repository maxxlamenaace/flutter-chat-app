import 'dart:async';

import 'package:chat_app/colors.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:chat_app/states-management/message-thread/message_thread_cubit.dart';
import 'package:chat_app/states-management/receipt/receipt_bloc.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/ui/widgets/common/header_status.dart';
import 'package:flutter/material.dart';

import 'package:chat/chat.dart';
import 'package:chat_app/states-management/home/chats/chats_cubit.dart';
import 'package:chat_app/states-management/message/message_bloc.dart';
import 'package:chat_app/states-management/typing/typing_notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesList extends StatefulWidget {
  final User receiver;
  final User activeUser;
  final String chatId;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  const MessagesList(this.receiver, this.activeUser, this.messageBloc,
      this.chatsCubit, this.typingNotificationBloc,
      {required this.chatId});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();

  List<LocalMessage> messages = [];

  late String chatId;
  late User receiver;
  late StreamSubscription? _subscription;

  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;

  @override
  void initState() {
    super.initState();

    chatId = widget.chatId;
    receiver = widget.receiver;

    _updateOnMessageReceived();
    _updateOnReceiptReceived();

    context
        .read<ReceiptBloc>()
        .add(ReceiptEvent.onSubscribed(widget.activeUser));

    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(
        widget.activeUser,
        usersWithChat: [receiver.id]));
  }

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) {
      messageThreadCubit.getMessages(chatId);
    }

    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.viewModel.receivedMessage(state.message);

        final receipt = Receipt(
            recipient: state.message.from,
            messageId: state.message.id,
            status: ReceiptStatus.READ,
            timestamp: DateTime.now());

        context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
      }

      if (state is MessageSentSuccess) {
        await messageThreadCubit.viewModel.sentMessage(state.message);
      }

      if (chatId.isEmpty) {
        chatId = messageThreadCubit.viewModel.chatId;
      }

      messageThreadCubit.getMessages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.getMessages(chatId);
        widget.chatsCubit.getChats();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subscription?.cancel();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Row(children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: isLightTheme(context) ? Colors.black : Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
              Expanded(
                  child: HeaderStatus(
                      receiver.username, receiver.photoUrl, receiver.isActive,
                      lastSeen: receiver.lastSeen))
            ])),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(children: [
              Flexible(flex: 6, child: Container()),
              Expanded(
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -3),
                                blurRadius: 6.0,
                                color: Colors.black12)
                          ],
                          color: isLightTheme(context)
                              ? Colors.white
                              : appBarDark),
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _buildMessageInput(context)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    child: RawMaterialButton(
                                        onPressed: () {},
                                        fillColor: appColor,
                                        shape: new CircleBorder(),
                                        elevation: 5,
                                        child: Icon(Icons.send,
                                            color: Colors.white)),
                                  ))
                            ],
                          ))))
            ])));
  }

  _buildMessageInput(BuildContext context) {
    final _border = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        borderSide: isLightTheme(context)
            ? BorderSide.none
            : BorderSide(color: Colors.grey.withOpacity(0.3)));

    return Focus(
        onFocusChange: (focus) {},
        child: TextFormField(
          controller: _textEditingController,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: Theme.of(context).textTheme.caption,
          cursorColor: appColor,
          onChanged: (value) {},
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            enabledBorder: _border,
            filled: true,
            fillColor:
                isLightTheme(context) ? appColor.withOpacity(0.1) : bubbleDark,
            focusedBorder: _border,
          ),
        ));
  }
}
