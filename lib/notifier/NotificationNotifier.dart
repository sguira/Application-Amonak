import 'dart:convert';

import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationState {
  int count;
  bool loading;
  bool isFirstLoad = true;
  bool isRead = false;
  List<NotificationModel> notifications = [];
  NotificationState(
      {this.count = 0,
      this.notifications = const [],
      this.loading = false,
      this.isFirstLoad = true,
      this.isRead = false});

  NotificationState copyWith({
    int? count,
    List<NotificationModel>? notifications,
    bool? isRead,
    bool? loading,
    bool? isFirstLoad,
  }) {
    return NotificationState(
        count: count ?? this.count,
        notifications: notifications ?? this.notifications,
        loading: loading ?? this.loading,
        isFirstLoad: isFirstLoad ?? this.isFirstLoad,
        isRead: isRead ?? this.isRead);
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
      : super(NotificationState(
            count: 0, notifications: [], loading: false, isFirstLoad: true));

  void addNotification(NotificationModel notification) {
    final updatedNotifications = [notification, ...state.notifications];
    state = state.copyWith(
      notifications: updatedNotifications,
      count: state.count + 1,
    );
  }

  Future<void> loadNotification({bool refresh = false}) async {
    if (state.isFirstLoad == false) return;
    state = state.copyWith(notifications: []);
    try {
      state = state.copyWith(
        loading: true,
      );

      final response = await NotificationService.getNotification();
      state = state.copyWith(loading: false);
      if (response!.statusCode == 200) {
        final List<NotificationModel> fetched =
            (jsonDecode(response.body) as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();

        // List<NotificationModel> fetched = [];

        // for (var item in jsonDecode(response.body)) {
        //   // if (item['to'] == LocalStorage.getUserId()) {
        //   fetched.add(NotificationModel.fromJson(item));
        //   // }
        // }

        final List<NotificationModel> articles =
            refresh ? fetched : [...state.notifications, ...fetched];

        state = state.copyWith(
          loading: false,
          notifications: articles,
          isFirstLoad: false,
          count: articles.length,
        );
      } else {
        state = state.copyWith(loading: false);
      }
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  void readNotification() {
    state = state.copyWith(count: 0, isRead: true);
  }

  void addNewNotification(NotificationModel notif) {
    state = state.copyWith(notifications: [notif, ...state.notifications]);
  }
}

final notificationProdider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
        (ref) => NotificationNotifier());
