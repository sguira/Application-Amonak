import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/notifier/NotificationNotifier.dart';
import 'package:application_amonak/widgets/item_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationWidget extends ConsumerStatefulWidget {
  const NotificationWidget({super.key});

  @override
  ConsumerState<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends ConsumerState<NotificationWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(notificationProdider.notifier).loadNotification();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final asyncPublications = ref.watch(notificationProdider);

    if (asyncPublications.loading) {
      return const Center(child: CircularProgressIndicator());
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
                  style: GoogleFonts.roboto(
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
              itemCount: asyncPublications.notifications.length,
              itemBuilder: (context, index) {
                // final notification = asyncPublications.notifications[index];
                return ItemNotification(
                  notification: asyncPublications.notifications[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
