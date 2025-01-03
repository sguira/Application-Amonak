import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  List message=[];
  List receive=[];
  List send=[];
  MessageModel? mes;
  List<String> userId=[];
  loadMessage()async {
    return [
      userId=[],
      message=[],
      await MessageService.getMessage(params: {'to':DataController.user!.id,'distinct':'true'}).then((value){
        print(value.statusCode);
        if(value.statusCode==200){
          for(var item in jsonDecode(value.body)){
            if(item['to']!=null&&item['from']!=null){
              if(userId.contains(item['from']['_id'])==false){
                message.add(MessageModel.fromJson(item));
                mes=MessageModel.fromJson(item);
                print("le nom est : ${mes!.from.userName}");
                userId.add(item['from']['_id']);
                
              }
            }
          }
        }
      }).catchError((e){
        print("er");
      }), 
      await MessageService.getMessage(params: {'from':DataController.user!.id,'distinct':'true'}).then((value) {
        if(value.statusCode==200){
          for(var item in jsonDecode(value.body)){
            if(value.statusCode==200){
              if(item['to']!=null&&item['from']!=null){
                try{
                  if(userId.contains(item['to']['_id'])==false){
                    message.add(MessageModel.fromJson(item));
                    userId.add(item['to']['_id']);
                  }
                }
                catch(e){
                  print("ERROR $e \t name:${item['to']['userName']}");
                }
              }
            }
          }
        }
      }).catchError((e){})
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:const EdgeInsets.all(12),
        child: ListView(
          children: [
            Container(
              child:Text("Discussions".toUpperCase(),style: GoogleFonts.roboto(fontSize: 18,fontWeight: FontWeight.w700),), 
            ),
            FutureBuilder(
              future: loadMessage(),
              builder: (context,snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const WaitWidget();
                }
                if(snapshot.hasError){
                  return const Text("Une erreur est survenue !");
                }
                return Container(
                  margin:const EdgeInsets.symmetric(horizontal: 2,vertical: 16),
                  child: message.isNotEmpty?
                  Container(
                    child: Column(
                      children: [
                        for(MessageModel item in message)
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage(user:item.iSend? item.to:item.from) ));
                          },
                          child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // margin: ,
                                  width: 55, 
                                  height: 55, 
                                  child: ClipOval(
                                    child: item.to.avatar!.isEmpty? Image.asset("assets/medias/profile.jpg",fit: BoxFit.cover,):Image.network(item.to.avatar!.first.url!,fit: BoxFit.cover,),
                                  ),
                                ), 
                                Container(
                                  constraints: BoxConstraints(maxWidth: ScreenSize.width*0.6),
                                  margin:const EdgeInsets.only(left: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.iSend==true? item.to.userName!:item.from.userName,style:GoogleFonts.roboto(fontWeight: FontWeight.w700)),
                                      Row(
                                        children: [
                                          // Icon(FontAwesomeIcons.checkDouble,size: 16,),
                                          Text(item.content,style: GoogleFonts.roboto(fontSize:12)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(), 
                                const Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ): Container(
                    margin:const EdgeInsets.symmetric(vertical: 36),
                    child: Text("Aucun message envoyé pour le moment.",style: GoogleFonts.roboto(),),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}