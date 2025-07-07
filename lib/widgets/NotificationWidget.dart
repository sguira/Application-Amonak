import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/notifier/NotificationNotifier.dart';
import 'package:application_amonak/widgets/item_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPublications = ref.watch(notificationProvider);
    DataController.notificationCount = asyncPublications.value?.length ?? 0;
    print("Notification count: ${DataController.notificationCount}");
    return asyncPublications.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              "Aucune notification",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }
        return Scaffold(
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      tooltip: "Rafraîchir les notifications",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ItemNotification(
                        notification: notification,
                        reloadNotificationData: () {
                          ref
                              .read(notificationProvider.notifier)
                              .refreshPublications();
                        });
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: Text(
            "Erreur de chargement des notifications",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
