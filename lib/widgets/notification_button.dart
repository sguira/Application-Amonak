import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/notifier/NotificationNotifier.dart';
import 'package:application_amonak/widgets/NotificationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonNotificationWidget extends ConsumerWidget {
  final Color? color;
  const ButtonNotificationWidget({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProdider);
    return state.count > 0
        ? Badge(
            label: Text(state.count.toString(),
                style: const TextStyle(color: Colors.white)),
            offset: const Offset(0.5, 0.5),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationWidget()));
                  ref.read(notificationProdider.notifier).readNotification();
                },
                icon: Icon(FontAwesomeIcons.bell, color: color)),
          )
        : IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationWidget()));
              ref.read(notificationProdider.notifier).readNotification();
            },
            icon: Icon(FontAwesomeIcons.bell, color: color));
  }
}
