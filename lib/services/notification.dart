import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<http.Response> addNotification(Map data) async {
    return await http
        .post(Uri.parse("$apiLink/notifications"),
            headers: authHeader, body: jsonEncode(data))
        .then((value) {
      print(value.statusCode);
      return value;
    }).catchError((e) {
      return e;
    });
  }

  static Future<http.Response?> getNotification() async {
    String userId = await LocalStorage.getUserId();
    if (userId != null) {
      return await http
          .get(
              Uri.parse("$apiLink/notifications").replace(queryParameters: {
                'user': userId,
                'status': true.toString(),
                'limit': 202.toString()
              }),
              headers: authHeader)
          .then((value) {
        print("Appel notification");
        print(value.statusCode);

        return value;
      }).catchError((e) {
        print("Erreur avec les notifications $e");
        return e;
      });
    }
    return null;
  }

  static Future<http.Response> deleteNotification(String id) {
    return http
        .delete(Uri.parse("$apiLink/notifications/$id"), headers: authHeader)
        .then((value) {
      return value;
    }).catchError((e) {
      return e;
    });
  }
}
