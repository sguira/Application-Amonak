import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/widgets/circular_progressor.dart';
import 'package:application_amonak/widgets/item_notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ListeNotification extends StatefulWidget {
  const ListeNotification({super.key});

  @override
  State<ListeNotification> createState() => _ListeNotificationState();
}

class _ListeNotificationState extends State<ListeNotification> {

  List<NotificationModel> notifications=[];

  late MessageSocket messageSocket;

  late Future<String> data;

  Future<String> initNotification()async{
    await NotificationService.getNotification().then((value){
      print("Notifications liste status code ${value.statusCode}");
      if(value.statusCode==200){
        print(value.body);
        for(var notif in jsonDecode(value.body) as List){
            
            NotificationModel notificationModel=NotificationModel.fromJson(notif);
            
            setState(() {
              notifications.add(notificationModel);
            });
        }
      }
    });
    return "bien chargé";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageSocket=MessageSocket();
    data=initNotification();

    //ecoute de nouveau notification
    messageSocket.socket!.on("refreshNotificationBoxHandler", (handler){
      print("Nouvelle Notification recu");
      setState(() {
        initNotification();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:const Color(0x1F9F9FF),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          children: [
            Spacer(),
            Text("Notifications".toUpperCase(),style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),),
            Spacer(),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close))
          ],
        ),
      ),
      body:  FutureBuilder(future:data, builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return circularProgression();
        }
        else if(snapshot.hasError){
          return Text("Error");
        }
        else{
          return notifications.isNotEmpty? Container(
              decoration:const BoxDecoration(
                // color: Color(0x1F9F9FF)
                color: Colors.white
              ),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context,index){
                return ItemNotification(notification: notifications[index]);
              },
            ),
          ):Container();
        }
      })
    );
  }
}