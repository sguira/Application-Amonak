import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessagePage extends StatefulWidget {
  final User user;
  const MessagePage({super.key,required this.user});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  TextEditingController message=TextEditingController();

  bool waitingSend=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 70,
      //   titleSpacing: 12,
      //   title: 
      // ),
      body: Container(
        child: Column(
          children: [
            headerMessage(), 
            Expanded(
              child: FutureBuilder(
                future: MessageService.getMessage(from: DataController.user!.id!, to: widget.user.id!).then((value){
                  
                }),
                builder: (context,snapshot) {
                  return ListView(
                    children: [
                  
                    ],
                   );
                }
              )
            ), 
            Container(
              height: 70,
              margin:const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 38,
                      child: TextFormField(
                        controller: message, 
                        style: GoogleFonts.roboto(fontSize: 12),
                        decoration: InputDecoration(
                          contentPadding:const EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                          hintText: 'Ecrivez votre message', 
                          hintStyle: GoogleFonts.roboto(fontSize:12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36)
                          ),
                        ),
                      ),
                    ),
                  ), 
                  Container(
                    margin:const EdgeInsets.only(top: 14),
                    child:
                    IconButton(
                      
                      icon: !waitingSend? Column(
                        children: [
                          const Icon(Icons.send,size: 18,), 
                          Text('Envoyer',style: GoogleFonts.roboto(fontSize: 9),)
                        ],
                      ):Container(
                        margin:const EdgeInsets.only(bottom: 16),
                        child:const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.5,),
                        ),
                      ),
                      onPressed: (){
                        sendMessage();
                      }, 
                      
                     )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(){
    if(message.text!=''){
      setState(() {
        waitingSend=true;
      });
      MessageModel messageModel=MessageModel();
      messageModel.from=DataController.user!;
      messageModel.to=widget.user;
      messageModel.content=message.text;
      MessageService.sendMessage(messageModel).then((value) {
        setState(() {
          waitingSend=false;
        });
        print("Value $value");
      }).catchError((e){
        print(e);
      });
    }
    // else{
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer un message',style: GoogleFonts.roboto(),)));
    // }
  }

  Padding headerMessage() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin:const EdgeInsets.symmetric(vertical: 12),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     width: 1, 
          //     color: couleurPrincipale. 
          //   )
          // ),
          child: Row(
            children: [
              Container(
                margin:const EdgeInsets.symmetric(vertical: 12),
                width: 40, 
                height: 40,
                child: ClipOval(
                  child: Image.network('https://picsum.photos/200/300', width: 40,fit: BoxFit.cover,)
                ),
              ), 
              Container(
                margin:const EdgeInsets.symmetric(horizontal: 22),
                child: Text(widget.user.userName!.toUpperCase(),style:GoogleFonts.roboto(fontSize:13,fontWeight:FontWeight.w600)),
              ),
              const Spacer(), 
              Container(
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:const  Icon(Icons.close)),
              )
            ],
          ),
        ),
      );
  }
}