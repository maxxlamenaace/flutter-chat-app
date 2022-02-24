import 'package:chat_app/data/datasource.dart';
import 'package:chat_app/models/local_message.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/chat.dart';

abstract class BaseViewModel {
  IDataSource _dataSource;

  BaseViewModel(this._dataSource);

  @protected
  Future<void> addMessage(LocalMessage localMessage) async {
    if (!await _isExistingChat(localMessage.chatId)) {
      await _createNewChat(localMessage.chatId);
    }

    await _dataSource.addMessage(localMessage);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _dataSource.addChat(chat);
  }
}
