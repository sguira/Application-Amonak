import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/button_importer_fichier.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/multiline_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class CreatePublication extends StatefulWidget {
  const CreatePublication({super.key});

  @override
  State<CreatePublication> createState() => _CreatePublicationState();
}

class _CreatePublicationState extends State<CreatePublication> {

  TextEditingController texte = TextEditingController();

  File? selectedFile; 
  ImagePicker _picker=ImagePicker();
  String messageAlerte="";
  bool waitPublication=false;
  String? code;
  String type='';
  final formKey=GlobalKey<FormState>();
  IO.Socket? socket;

  initSocket(){
    socket=IO.io(
      apiLink+"/publication",
      IO.OptionBuilder()
      .setPath("/amonak-api")
      .setTransports(["websocket"])
      .setExtraHeaders({
        "Authorization": "Bearer $tokenValue",
        "userId":DataController.user!.id
      })
      .build()
    );
    // print("Sock");
    socket!.onConnect((_){
      print("Socket connecté.");
    });

    socket!.onError((_){
      print("Socket erreur");
    });

    socket!.onDisconnect((_){
      print("Socket déconnecté");
    });
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Publication");
    initSocket();
  }

  @override
  void dispose() {
    socket!.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 18),
      child: ListView(
        children: [
          headerBottomSheet(context, 'Faire Une publication'),
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 18),
                    child: Text('Exprime toi librement sur les sujets qui te passionnent. Amonak respecte la liberté d’expression. Veuillez tout de même rester poli.',style: GoogleFonts.roboto(fontSize: 12),textAlign: TextAlign.start,),
                  ), 
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          multilineTexteForm(controller: texte, hint: 'Dis le...'), 
                          buttonImportFile(label: 'Importer une photo / vidéo',function: choiceTypeFile), 
                          // TextFormField(
                            
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(36),
                          //     ), 
                          //     labelText: 'Ajouter une photo',
                          //   ),
                            
                          // ),
                          if(selectedFile!=null&&kIsWeb==false)
                          FileSelectedViewer(file: selectedFile!, onClose: onClose,type: type,),
                          Container(
                            margin:const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              gradient:const LinearGradient(
                                colors: [
                                  Color.fromRGBO(97, 81, 212, 1), 
                        // Color.fromARGB(255, 9, 51, 189),
                                Color.fromRGBO(132, 62, 201, 1)
                                  ]
                              ), 
                              
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(),
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                  if(selectedFile!=null){
                                    savePublication();
                                  }
                                }
                              },
                              child: Center(child:waitPublication==false? Text('publier',style: GoogleFonts.roboto(fontSize: 12,color: Colors.white)):const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,),))
                            ),
                          ), 
                          code!=null? alerteMessagePublication(messageAlerte,code!):Center()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  onClose(){
    setState(() {
      selectedFile=null;
    });
  }

  choiceTypeFile(){
    return showDialog(context: context, builder:(context)=> AlertDialog(
      // title: Text('Choisir le type de fichier',style: GoogleFonts.roboto()), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), 
      elevation: 0, 
      backgroundColor: Colors.transparent,
      
      content: Container(
        margin:const EdgeInsets.symmetric(horizontal: 75),
        height: 260,
        width: 50,
        padding:const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: couleurPrincipale, 
          borderRadius: BorderRadius.circular(100)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: (){
                choiceFile('image');
              },
              icon: Column(
                children: [
                  const Icon(Icons.photo,size: 32,color: Colors.white,),
                  Text('Photo',style: GoogleFonts.roboto(color:Colors.white),)
                ],
              )
            ), 
            IconButton(
              onPressed: (){
                choiceFile('video');
              },
              icon: Column(
                children: [
                  const Icon(Icons.video_camera_back_outlined,size: 32,color: Colors.white,),
                  Text('Video',style: GoogleFonts.roboto(color: Colors.white,),)
                ],
              )
            ), 
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Column(
                children: [
                  const Icon(Icons.close,color:Colors.white,size: 16,),
                  Text('Fermer',style: GoogleFonts.roboto(fontSize: 9,color: Colors.white),)
                ],
              )
            )
          ],
        ),
      ),
    ));
  }

  Container alerteMessagePublication(String message,String code) {
    return Container(
                          padding:const EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 84, 163, 87), 
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(code=='OK'? Icons.check:Icons.close,size: 18,color: Colors.white,), 
                              const SizedBox(width: 22,),
                              Text(messageAlerte,style: GoogleFonts.roboto(fontSize: 12,color: Colors.white),)
                            ],
                          ),
                        );
  }

  void savePublication(){
    if(selectedFile!=null){
      print(' test');
      setState(() {
        waitPublication=true;
      });
      PublicationService.uploadFileOnserver(file: selectedFile!,description: texte.text ).then((value) {
        setState(() {
          waitPublication=false;
        });
        code=value['code'];
        if(code=='OK'){
            socket!.emit("newPublicationEvent",{"type":"mobile","data":jsonDecode(value['data'])});
          setState(() {
            messageAlerte='Publication réussie';
          });
          Future.delayed(const Duration(milliseconds: 800),(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageTab() ));
          });
        }
        else{
          setState(() {
            messageAlerte='Erreur de publication';
          });
        }
      }).catchError((e){
        print("ERROR $e\n\n");
      });
    }
  }

  choiceFile(String type_)async{
    final XFile? file;
    type=type_;
    if(type=='image'){
      file=await _picker.pickImage(source: ImageSource.gallery);
      print("nom de fichier ${file!.path}");
    }
    else{
      file=await _picker.pickVideo(source: ImageSource.gallery);
    }
    if(file!=null){
      setState(() {
        selectedFile=File(file!.path);
        print("File ok");
      });
    }
    Navigator.pop(context);

  }

  loadFile(){
    choiceFile('image');
  }

  Container DescriptionFileLoad() {
    return Container(
                margin:const EdgeInsets.symmetric(horizontal: 6),
                // width: 250,
                // constraints: BoxConstraints(maxWidth: ScreenSize.width*0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Fichier chargé :${selectedFile!.path.split('/').last}',style: GoogleFonts.roboto(fontSize:11,color:Colors.red,decoration: TextDecoration.underline),overflow: TextOverflow.visible,)),
                    
                    IconButton(onPressed: (){
                      setState(() {
                        selectedFile=null;
                      });
                    }, icon:const Icon(Icons.close,size: 18,))
                  ],
                ));
  }
}