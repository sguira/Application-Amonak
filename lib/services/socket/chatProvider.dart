

import 'dart:async';
import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class MessageSocket extends ChangeNotifier{

  IO.Socket? socket;
  List<User> users=[];
  // List<MessageModel> messages=[];
  User? userAuth=DataController.user!;

  StreamController<DateTime> _timeController=StreamController<DateTime>();

  MessageSocket(){
    // connectToServer();
    _initializeChat();
  }

  void _initializeChat(){
    _connectSocket();
    _startTimer();
  }

  void _connectSocket(){
    socket=IO.io(
      apiLink+"/chat", 
      IO.OptionBuilder()
      .setTransports(["websocket"])
      .setPath("/amonak-api")
      .setExtraHeaders({
        "Authorization":"Bearer $tokenValue", 
        "userId":"${DataController.user!.id}"
    }).build());
    // socket!.connect();
    socket!.onConnect((_){
      print("Connected to the server message");

     
    });

    socket!.onDisconnect((_){
      print("Disconnected from the server");
    });

    

    
    
  }

  void _startTimer(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      _timeController.add(DateTime.now());
    });
  }

  Stream<DateTime> get timeStream => _timeController.stream;

  // Future<void> fetchUsers() async {
  //   // Appel API pour récupérer la liste des utilisateurs
  //   await UserService.getAllUser().then((value){
  //     if(value.statusCode==200){
  //       users=[];
  //       for(var item in jsonDecode(value.body) as List){
  //         users.add(User.fromJson(item));
  //       }
  //     }
  //   });
  //   notifyListeners();
  // }

  Future<void> fetchMessages() async {
    print("recuperer message");
    // Appel API pour récupérer les messages
    // await MessageService.allMessageSendOrReceiveByUser(DataController.user!.id!).then((value){
    //   if(value.length!=0){
    //     messages=[];
    //     for(var item in value){
    //       print(item);
    //       messages.add(MessageModel.fromJson(item));
    //     }
    //   }
    // });
    notifyListeners();
  }

  @override
  void dispose() {
    _timeController.close();
    socket!.onDisconnect((_){
      print('Deconnecté');
    });
    super.dispose();
  }

}