import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/notification_button.dart';
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

  late MessageSocket socket; 

  @override
  void initState() {
    super.initState();
    // connectWebSocket();
    socket=MessageSocket();

    socket.socket!.on("refreshMessageBoxHandler", (handler){
      print("Nouveau Message ... $handler");
      if(handler['to']==DataController.user!.id){
        setState(() {
          // message=[];
          loadMessage();
        });
      }
    });
  }

  @override
  void dispose() {
    socket.socket!.close();
    super.dispose();
  }


  
  loadMessage()async {
    return [
      userId=[],
      message=[],
      await MessageService.getMessage(params: {'to':DataController.user!.id,'notRead':false,'distinct':true},).then((value){
        print(value.statusCode);
        if(value.statusCode==200){
          for(var item in jsonDecode(value.body)){
            if(item['to']!=null&&item['from']!=null){
              message.add(MessageModel.fromJson(item));
                mes=MessageModel.fromJson(item);
                print("le nom est : ${mes!.from.userName}");
                userId.add(item['from']['_id']);
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
                  message.add(MessageModel.fromJson(item));
                      userId.add(item['to']['_id']);
                      print("le nom est : ${mes!.from.userName}");
                  if(userId.contains(item['to']['_id'])==false){
                   
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
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discussions".toUpperCase(),style: GoogleFonts.roboto(fontSize: 18,fontWeight: FontWeight.w700),),
                  const ButtonNotificationWidget()
                ],
              ), 
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
                            constraints: const BoxConstraints(
                              maxHeight: 88
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin:const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
                                  padding:const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        // margin: ,
                                        padding:const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(36),
                                          
                                          border: Border.all(
                                            width: 1.5,
                                            color: couleurPrincipale
                                            
                                          )
                                        ),
                                        width: 36, 
                                        height: 36, 
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(11),
                                          child: item.to.avatar!.isEmpty? Image.asset("assets/medias/profile.jpg",fit: BoxFit.cover,):Image.network(item.to.avatar!.first.url!,fit: BoxFit.fitHeight,errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                                "assets/medias/profile.jpg",
                                                fit: BoxFit.cover,
                                                width: 48,
                                                height: 48,
                                              );
                                          },),
                                        ),
                                      ), 
                                      Container(
                                        constraints: BoxConstraints(maxWidth: ScreenSize.width*0.6),
                                        margin:const EdgeInsets.only(left: 16),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.iSend==true? item.to.userName!:item.from.userName,style:GoogleFonts.roboto(fontWeight: FontWeight.w600)),
                                            Row(
                                              children: [
                                                // Icon(FontAwesomeIcons.checkDouble,size: 16,),
                                                Container(
                                                  constraints:const BoxConstraints(
                                                    maxWidth: 200
                                                  ),
                                                  child: Text(item.content,style: GoogleFonts.roboto(fontSize:12))),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(), 
                                      const Icon(Icons.arrow_right_outlined,color: couleurPrincipale,)
                                    ],
                                  ),
                                ),
                                const Divider()
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