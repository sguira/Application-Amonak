import 'dart:convert';

import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/widgets/item_notification.dart';
import 'package:application_amonak/widgets/list_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GestionProfilePage extends StatefulWidget {
  const GestionProfilePage({super.key});

  @override
  State<GestionProfilePage> createState() => _GestionProfilePageState();
}

class _GestionProfilePageState extends State<GestionProfilePage> {

  // List<NotificationModel> notifications=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initNotification();
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context: context,title: ''),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin:const EdgeInsets.symmetric(vertical: 12),
                child: Text("gérer ma boutique".toUpperCase(),style: GoogleFonts.roboto(fontSize:14,fontWeight:FontWeight.bold),),
              ),
            ), 
            Expanded(
              child: DefaultTabController(
                length: 2, child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(tabs: [
                      itemTab("portefeuille"), 
                      itemTab("statistique")
                    ]),
                  ),
                  body: PageView(
                    children: [
                      ListeNotification(),
                      Container()
                    ],
                  ),
                ), 
                
              )
            )
          ],
        ),
      ),
    );
  }

  listeNotification(List<NotificationModel> notifications){
    return Container(
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context,index){
          return ItemNotification(notification: notifications[index]);
        },
      ),
    );
  }

  AppBar customAppBar({
    required BuildContext context, 
    String? title
  }) {
    return AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:const Icon(Icons.arrow_back,size: 18,)),
        title:title!=null? Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){}, child: Text('Se déconnecter'.toUpperCase(),style: GoogleFonts.roboto(fontSize: 11,decoration: TextDecoration.underline),)),
              TextButton(onPressed: (){}, child: Text('Editer'.toUpperCase().toUpperCase(),style: GoogleFonts.roboto(fontSize: 11),))

            ],
          )
        ):null,
        centerTitle: false,
      );
  }

  Tab itemTab(String label) => Tab(child: Text(label.toUpperCase(),style: GoogleFonts.roboto(fontSize: 12),),);
}