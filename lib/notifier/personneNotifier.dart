import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonneState {
  bool loading = false;
  List<User> users = const [];
  String? error = '';
  bool? hasMoreElement;
  bool? firsLoading;
  List<User>? friends = const [];

  PersonneState(
      {this.error,
      this.hasMoreElement,
      required this.users,
      required this.loading,
      this.firsLoading,
      this.friends});

  PersonneState copyWith(
      {String? error,
      bool? loading,
      bool? hasMoreElement,
      List<User>? users,
      bool? firsloading,
      List<User>? friends}) {
    return PersonneState(
        users: users ?? this.users,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        hasMoreElement: hasMoreElement ?? this.hasMoreElement,
        firsLoading: firsloading ?? this.firsLoading,
        friends: friends ?? this.friends);
  }
}

class PersonneNotifier extends StateNotifier<PersonneState> {
  PersonneNotifier()
      : super(PersonneState(
            users: [], friends: [], loading: false, firsLoading: true));

  Future<void> loadingUser({bool? refres = false, String? query}) async {
    if (state.firsLoading == false && refres == false) return;
    try {
      state = state.copyWith(loading: true);
      final response = await UserService.getAllUser(param: {'search': query});
      final friendRequest = await UserService.getAllUser(param: {
        "friendRequest": true.toString(),
        "user": DataController.user!.id,
      });
      state = state.copyWith(loading: false, firsloading: false);
      print('valeurs ${response} ');
      if (response.statusCode == 200) {
        List<User> fetched = [];
        for (var item in jsonDecode(response.body)) {
          try {
            print("une personne ${item}");
            fetched.add(User.fromJson(item));
          } catch (e) {
            print("Error Chargement personne: ${e.toString()}");
          }
        }
        state = state.copyWith(users: fetched);
      } else {
        // state=state.copyWith(er)
        state = state.copyWith(loading: false);
      }
      if (friendRequest.statusCode == 200) {
        List<User> friend = [];
        for (var item in jsonDecode(friendRequest.body)) {
          try {
            friend.add(User.fromJson(item));
          } catch (e) {}
        }
        state = state.copyWith(friends: friend);
      }
      state = state.copyWith(loading: false);
    } catch (e) {
      print("une erreur est survenu:${e.toString()}");
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final personneNotifier = StateNotifierProvider<PersonneNotifier, PersonneState>(
    (ref) => PersonneNotifier());
