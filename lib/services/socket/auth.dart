import "dart:io";

import "package:application_amonak/data/data_controller.dart";
import "package:application_amonak/prod.dart";
import "package:application_amonak/services/storage/authStorage.dart";
import "package:socket_io_client/socket_io_client.dart" as IO;

class AuthSocket{
  late IO.Socket socket;

  late String token="";
  late String userId="";
  
  String url=apiLink;
  AuthSocket({
    required String path
  }){
    initializeData();
    
    socket = IO.io('$apiLink/auth',
      IO.OptionBuilder()
      .setTransports(["websocket"])
      .setPath(path)
      .setExtraHeaders({
        "Authorization":"Bearer $tokenValue", 
        "userId":"${DataController.user!.id}"
      }).build()

    );

    _initListeners();
  }

  initializeData()async{
    await AuthStorage.getValue("token").then((value){
      print("Mon token $token\n\n");
      token=value;
    });
    await AuthStorage.getValue("userId").then((value){
      userId=value;
    });
  }

  void _initListeners(){
    socket.onConnect((_){
      print("Socket Connecté \n\n");
    });
    
    socket.onError((value){
      // print("Socket Error $value \n\n");
    });

    socket.onDisconnect((_){
      print("Deconnecté");
    });
  }
}