import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  List message=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MessageService.getMessage(from: DataController.user!.id!,to: null).then((value) {
          if(value.statusCode==200){
            print("body message ${value.body}\n\n\n");
            for(var item in jsonDecode(value.body) as List){
              if(item['from']!=null&&item['to']!=null){
                print("item $item\n\n\n");
                try{
                  message.add(MessageModel.fromJson(item));
                }
                catch(e){
                  print("Error $e");
                }
              }
            }
          }
        }).catchError((e){
          print(e);
        }),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const WaitWidget();
          }
          if(snapshot.hasError){
            return Text("Une erreur est survenue !");
          }
          return Container(
            margin:const EdgeInsets.symmetric(horizontal: 18,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Discussions",style: GoogleFonts.roboto(fontSize: 28,fontWeight: FontWeight.w700),), 
          
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            for(var i in message)
                            Container(
                              margin:const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
                              padding:const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1, 
                                  color: couleurPrincipale.withAlpha(40)
                                ), 
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // margin: ,
                                    width: 55, 
                                    height: 55, 
                                    child: ClipOval(
                                      child: Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,),
                                    ),
                                  ), 
                                  Container(
                                    constraints: BoxConstraints(maxWidth: ScreenSize.width*0.6),
                                    margin:const EdgeInsets.only(left: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Guira Souleymane",style:GoogleFonts.roboto(fontWeight: FontWeight.w700)),
                                        Text('bonjour souley je veux commender un article',style: GoogleFonts.roboto(fontSize:12))
                                      ],
                                    ),
                                  ), 
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}