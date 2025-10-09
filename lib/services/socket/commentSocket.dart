import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/prod.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class Commentsocket extends ChangeNotifier {
  IO.Socket? socket;

  Commentsocket() {
    socket = IO.io(
        "$apiLink/comment",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            // .disableAutoConnect()
            // .enableMultiplex()
            .setPath("/amonak-api")
            .setExtraHeaders({
              "Authorization": "Bearer $tokenValue",
              "userId": DataController.user!.id
            })
            .build());

    socket!.onConnect((handler) {
      print("Commentaire socket connecté");
    });
  }

  void emitEvent({required String event, required dynamic data}) {
    print("Emition");
    socket!.emit("newCommentEvent", {"comment": data});
  }

  @override
  void dispose() {
    socket!.close();
    // super.dispose();
  }
}
