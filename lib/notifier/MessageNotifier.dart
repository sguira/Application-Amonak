import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/services/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageState {
  final List<MessageModel> messages;
  final bool? firstLoading;
  final bool? isLoad;
  final List<String>? user;
  final String? hasError;
  final bool? newMessage;

  MessageState(
      {required this.messages,
      this.isLoad,
      this.firstLoading,
      this.user,
      this.hasError,
      this.newMessage}) {}

  MessageState copyWith(
      {List<MessageModel>? messages,
      bool? firstLoading,
      String? hasError,
      bool? newMessage,
      bool? isLoad,
      List<String>? user}) {
    return MessageState(
        messages: messages ?? this.messages,
        user: user ?? this.user,
        isLoad: isLoad ?? this.isLoad,
        newMessage: newMessage ?? this.newMessage,
        firstLoading: firstLoading ?? this.firstLoading,
        hasError: hasError ?? this.hasError);
  }
}

class MessageNotifier extends StateNotifier<MessageState> {
  MessageNotifier()
      : super(MessageState(
          messages: [],
          firstLoading: true,
          isLoad: false,
          hasError: null,
          newMessage: false,
          user: [],
        ));

  loadMessage({required bool? refresh}) async {
    print("Chargement");
    if (state.firstLoading != true && refresh != true) {
      return;
    }
    state = state.copyWith(isLoad: true);
    await MessageService.getMessage(
      params: {
        'to': DataController.user!.id,
        'notRead': false,
        'distinct': true
      },
    ).then((value) {
      print("Cgargement des message");
      if (value.statusCode == 200) {
        state = state.copyWith(isLoad: false);
        state = state.copyWith(hasError: null);
        final List<MessageModel> message = [];
        for (var item in jsonDecode(value.body)) {
          if (item['to'] != null && item['from'] != null) {
            // message.add(MessageModel.fromJson(item));
          }
        }
        state = state.copyWith(firstLoading: false, messages: message);
      }
    }).catchError((e) {
      print("Error $e");
      e.call();
      state = state.copyWith(hasError: e.toString(), isLoad: false);
    });
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, MessageState>(
    (ref) => MessageNotifier());
