import 'dart:convert';

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
    List<MessageModel> message = [];
    List<String> userId = [];
    // await MessageService.getMessage(
    //   params: {
    //     'to': DataController.user!.id,
    //     'notRead': 'false',
    //     'distinct': 'true'
    //   },
    // ).then((value) {
    // print(value.statusCode);
    // if (value.statusCode == 200) {
    //   for (var item in jsonDecode(value.body)) {
    //     if (item['to'] != null && item['from'] != null) {
    //       message.add(MessageModel.fromJson(item));

    //       // userId.add(item['from']['_id']);
    //     }
    //   }
    // }
    // }).catchError((e) {
    //   print("er");
    //   state = state.copyWith(hasError: e.toString());
    // });
    await MessageService.getMessage(
            params: {'from': DataController.user!.id, 'distinct': 'true'})
        .then((value) {
      if (value.statusCode == 200) {
        for (var item in jsonDecode(value.body)) {
          if (item['to'] != null && item['from'] != null) {
            try {
              message.add(MessageModel.fromJson(item));
              userId.add(item['to']['_id']);
              print("USER ID ADD: $item");
              if (userId.contains(item['to']['_id']) == false) {}
            } catch (e) {
              print("ERROR $e \t name:${item['to']['userName']}");
            }
          }
        }
      }
    }).catchError((e) {
      state = state.copyWith(hasError: e.toString());
    });

    state = state.copyWith(
        messages: message,
        user: userId.toSet().toList(),
        firstLoading: false,
        isLoad: false);
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, MessageState>(
    (ref) => MessageNotifier());
