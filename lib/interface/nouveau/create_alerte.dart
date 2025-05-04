import 'dart:io';

import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/button_importer_fichier.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/item_form.dart';
import 'package:application_amonak/widgets/multiline_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class CreateAlertePage extends StatefulWidget {
  const CreateAlertePage({super.key});

  @override
  State<CreateAlertePage> createState() => _CreateAlertePageState();
}

class _CreateAlertePageState extends State<CreateAlertePage> {

  TextEditingController texte=TextEditingController();

  File? selectedFile;
  final ImagePicker _picker=ImagePicker();

  bool waitAlerte=false; 
  TextEditingController description=TextEditingController();
  TextEditingController articleName=TextEditingController();
  final keyForm=GlobalKey<FormState>();

  String message="";
  bool alerte=false;
  int alerteCode=0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 0),
      child: ListView(
        children: [
          headerBottomSheet(context, 'Faire Une Alerte'),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Si vous recherchez un article rare et/ou urgent, c’est le moment d’alerter les vendeurs qui peuvent potentiellement vous faire des propositions.",style: GoogleFonts.roboto(fontSize: 12),textAlign: TextAlign.start,),
                ), 
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 18),
                  child: Form( 
                    key: keyForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        multilineTexteForm(controller: description, hint: "De quoi parle t'on Aujourd'hui"), 
                        itemForm(hint: 'Ex. Chaussure Givenchy paris', label: "Nom de l’article",controller: articleName,requiet: true), 
                        buttonImportFile(label: 'Importer une photo / vidéo de l’article',function: loadFile),
                        if(selectedFile!=null)
                        FileSelectedViewer(file: selectedFile!, onClose: onClose),
                        if(alerte)
                        Container(
                          margin:const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:const Color.fromARGB(255, 14, 111, 172), 
                            borderRadius: BorderRadius.circular(28)
                          ),  
                          padding:const EdgeInsets.symmetric(vertical: 8,horizontal: 22),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(alerteCode==1? Icons.check:Icons.warning,color:Colors.white),
                                const SizedBox(width: 12,),
                                Text(message,style: GoogleFonts.roboto(color:Colors.white),)
                              ],
                            ),
                          ),
                        ), 
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
                                if(keyForm.currentState!.validate()){
                                  if(selectedFile!=null){
                                    saveAlerte();
                                  }
                                }
                              },
                              child: Center(child:waitAlerte==false? Text('ENVOYER',style: GoogleFonts.roboto(fontSize: 12,color: Colors.white)):const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,),))
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  onClose(){
    setState(() {
      selectedFile=null;
    });
  }

  Container DescriptionFileLoad() {
    return Container(
                margin:const EdgeInsets.symmetric(horizontal: 6),
                // width: 250,
                // constraints: BoxConstraints(maxWidth: ScreenSize.width*0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text('Video chargée :${selectedFile!.path.split('\\').last}',style: GoogleFonts.roboto(fontSize:11,color:Colors.red,decoration: TextDecoration.underline),overflow: TextOverflow.visible,)),
                    
                    IconButton(onPressed: (){
                      setState(() {
                        selectedFile=null;
                      });
                    }, icon:const Icon(Icons.close,size: 18,))
                  ],
                ));
  }

  choiceFile(String type)async{
    final XFile? file;

    if(type=='image'){
      file=await _picker.pickImage(source: ImageSource.gallery);
    }
    else{
      file=await _picker.pickVideo(source: ImageSource.gallery);
    }
    if(file!=null){
      setState(() {
        selectedFile=File(file!.path);
      });
    }

  }
  loadFile()async{
    await choiceFile('image');
  }

  saveAlerte()async{
    if(selectedFile!=null){
      setState(() {
        waitAlerte=true;
      });
      await PublicationService.uploadFileOnserver(file: selectedFile!,description: description.text,type: 'alerte', articleName:articleName.text  ).then((value){
        setState(() {
          waitAlerte=false;
        });
        if(value=='OK'){
          description.text='';
          articleName.text='';
          selectedFile=null;
         setState(() {
            message="Votre alerte à été publiée !";
            alerte=true;
            alerteCode=1;
         });
         Future.delayed(const Duration(milliseconds: 800),(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageTab() ));
                        });
        }
        else{
          message="Une erreur est survenue !";
          alerte=true;
          alerteCode=2;
        }
      }).catchError((e){
        setState(() {
          waitAlerte=false;
        });
      });
    }
  }
}