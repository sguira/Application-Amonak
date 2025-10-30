import 'dart:convert';

import 'package:application_amonak/interface/contact/contact.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/interface/publication/details_publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationLocalService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // ⚙️ Configuration Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 🍏 Configuration iOS
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 🪟 Configuration Windows
    var uuid = const Uuid();
    WindowsInitializationSettings windowsSettings =
        WindowsInitializationSettings(
      appName: 'AmonakApp',
      appUserModelId: 'com.amonak.application',
      guid: uuid.v4(),
    );

    // 🔧 Paramètres globaux
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );

    // 🚀 Initialisation du plugin
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // ✅ Android 13+ → permission via permission_handler
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      debugPrint("🔔 Permission Android accordée : ${status.isGranted}");
    }

    // ✅ iOS → permission via API FlutterLocalNotifications
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    debugPrint("✅ NotificationService initialized");
  }

  static Future<void> showNotification(
      {required String title, required String body, String? payload}) async {
    // ✅ Canal Android obligatoire
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'message_channel_id',
      'Messages',
      description: 'Notification des nouveaux messages',
      importance: Importance.max,
    );

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    // 🔔 Détails Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('message_channel_id', 'Messages',
            channelDescription: 'Notification des nouveaux messages',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: "amonak");

    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails(presentAlert: true, presentSound: true);

    // 🪟 Détails Windows
    const WindowsNotificationDetails windowsDetails =
        WindowsNotificationDetails();

    // 🧩 Détails globaux
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      windows: windowsDetails,
    );

    // 🚀 Affichage
    await _notificationsPlugin.show(0, title, body, details, payload: payload);

    debugPrint("📩 Notification envoyée : $title - $body");
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint("🟡 iOS Local Notification received: $title $body");
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    if (response.payload != null &&
        response.payload!.isNotEmpty &&
        jsonDecode(response.payload!)['route'] == "message") {
      final userData = await UserService.getUser(
              userId: response.payload != null
                  ? jsonDecode(response.payload!)['id']
                  : "")
          .then((value) {
        if (value.statusCode == 200) {
          User u = User.fromJson(jsonDecode(value.body));
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => MessagePage(user: u)),
          );
        }
      });
    }

    if (response.payload != null &&
        response.payload!.isNotEmpty &&
        jsonDecode(response.payload!)['route'] == "publication") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => DetailsPublication(
                  pubId: response.payload != null
                      ? jsonDecode(response.payload!)['id']
                      : "",
                )),
      );
    }

    debugPrint("🔵 Notification tap: ${response.payload}");
  }
}
