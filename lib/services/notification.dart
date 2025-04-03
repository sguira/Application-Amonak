import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;
class NotificationService{

  static Future<http.Response> addNotification(Map data)async{
    return await http.post(Uri.parse("$apiLink/notifications"),headers:authHeader,body:jsonEncode(data)).then((value){
      print(value.statusCode);
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> getNotification()async{
    return await http.get(Uri.parse("$apiLink/notifications").replace(
      queryParameters: {
        'user':DataController.user!.id, 
        'status':true.toString(),
        // 'limit':100
      }
    ),headers: authHeader).then((value){
      print("Appel notification");
      print(value.statusCode);

      return value;
    }).catchError((e){
      print("Erreur avec les notifications $e");
      return e;
    });
  }

}