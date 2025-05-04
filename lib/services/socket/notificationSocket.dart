import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Notificationsocket extends ChangeNotifier {

  IO.Socket? socket;
  List<dynamic> notification=[];
  Notificationsocket(){
    _initSocket();
  }

  _initSocket(){
      socket=IO.io(
        "$apiLink/chat", 
        IO.OptionBuilder()
        .setPath("/amonak-api")
        .setTransports(["websocket"])
        .enableMultiplex()
        .setExtraHeaders(
          {
            "Authorization":"Bearer $tokenValue", 
            "userId":DataController.user!.id
          }
        ).build()
    );

    socket!.onConnect((_){
      print("Connected to notificaation socket");
    });

    socket!.onDisconnect((_){
      print("Disconnected from notificaation socket");
    });

    socket!.on("refreshNotificationBoxHandler", (data){
      print("Nouvelle notification d: $data");
      NotificationService.getNotification().then((value){
        if(value.statusCode==200){
          for(var item in jsonDecode(value.body) as List){
            print("value:$item");
            notification.add(NotificationModel.fromJson(item));
          }
        }
      });
      notifyListeners();
    });
  }

  emitNotificationEvent({
    required String event,
    required dynamic data,
  }){

    socket!.emit(event, data);
  }

  @override
  void dispose() {
    socket!.close();
    super.dispose();
  }

}