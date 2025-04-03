import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class PublicationSocket extends ChangeNotifier{

  IO.Socket? socket;

  List<Publication> publication=[];

  PublicationSocket(){
    _initSocket();
  }

  void _initSocket()async {
    print("socket ...");
    _connexionSocket();
  }

  _connexionSocket(){
      socket=IO.io(
        apiLink+"/publication", 
        IO.OptionBuilder()
        .setTransports(["websocket"])
        .setPath("/amonak-api")
        .setExtraHeaders({
          "Authorization": "Bearer $tokenValue",
          "userId":DataController.user!.id
        })
        .build()
      ); 

      socket!.onConnect((_){
        print("des publications connectés");
        
        notifyListeners();
      });

     

      socket!.on("commentPublication",(data){
        print(data);
        print("Nouveau commentaire");
      });

      socket!.onError((_){
        print("Socket error");  
      });

      socket!.onDisconnect((_){
        print("Socket disconnected");
      });
    }

  bool _isConnect(){
    return socket!.connected;
  }

  void receiveEventByServer(
    {
      required String event, 
      required Function function
    }
  ){
    socket!.emit(event,(data){
      print("Nouvelle publication ee");
      function(data);
    });
  }

  void emitCreation({
    required String event,
    required Map<String,dynamic> data
  }){
    socket!.on(event,(data)=>{
      this.publication.insert(1, Publication.fromJson(data)),
      notifyListeners()
    });
  }

  

}