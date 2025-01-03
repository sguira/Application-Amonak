import 'dart:io';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/button_importer_fichier.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/item_form.dart';
import 'package:application_amonak/widgets/multiline_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';
class VendreArticle extends StatefulWidget {
  const VendreArticle({super.key});

  @override
  State<VendreArticle> createState() => _VendreArticleState();
}

class _VendreArticleState extends State<VendreArticle> {

  TextEditingController texte=TextEditingController();
  TextEditingController nomArticle=TextEditingController();
  TextEditingController prix=TextEditingController();
  TextEditingController qte=TextEditingController();
  TextEditingController devise=TextEditingController();
  final formKey =GlobalKey<FormState>();
  File? selectedFile;
  String? fileType;
  bool waitSale=false;
  bool fileError=false;
  bool responseShow=false;
  String responseMessage="";
  int responseType=2;
  final ImagePicker _picker=ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height*0.8,
      margin:const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          headerBottomSheet(context,"Vendre un article"), 
          Container(
            margin:const EdgeInsets.symmetric(horizontal: 8),
            child: Text("En mettant en vente votre article, vous le rendez accessible partout. Paiement en ligne et à la livraison sont autorisé. Chaque article vendu a une garantie de 24h.",style: GoogleFonts.roboto(fontSize:12),textAlign: TextAlign.start,),
          ), 
          itemFormContainer()
        ],
      ),
    );
  }

  

  itemFormContainer(){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            multilineTexteForm(hint: "Qu'est ce quon vend aujoud'hui",controller: texte,), 
            // itemForm(hint: 'Ex. Chaussure Givenchy paris', label: "Nom de l’article"), 
            // itemForm(hint: 'Ex. 8000', label: "Prix ( CFA XOF )"),
            // itemForm(hint: 'Ex. 100', label: "Quantité en Stock"), 
            // itemForm(hint: 'Ex. 8000', label: "Prix ( CFA XOF )"), 
            textFormField(label: "Nom de l'article",hint: "Ex. Chaussure Givenchy paris",controller: nomArticle,requiet: true,type:'texte'),
            textFormField(label: "Prix",hint: "Ex. 8000",controller: prix,requiet: true,type:'number'),
            // textFormField(label: "Dévise",hint: "Ex. CFA",controller: devise,requiet: false,type:'text'),
            Container(
              child:SelectFormField(
                controller: devise, 
                validator:(value){
                  if(value==null || value.isEmpty) return 'Veuillez choisir une devise';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Dévise",
                  hintStyle: GoogleFonts.roboto(),
                  contentPadding:const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
                  labelStyle: GoogleFonts.roboto(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(26)
                  ),
                  border:  OutlineInputBorder(
                    borderSide:const BorderSide(color: Colors.black12, width: 1.0),
                    borderRadius: BorderRadius.circular(26)
                  )
                ),
                items:const [
                  {
                    'label':'CFA', 
                    'value':'CFA',
                  }, 
                  {
                    'label':'DNT', 
                    'value':'DNT',
                  }
                ],
              )
            ),
            textFormField(label: "Quantité en Stock",hint: "Ex. 50",controller: qte,requiet: true,type:'number'),
        
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buttonImportFile(label: 'Importer la vidéo de votre article',function: loadFile  ),
                if(fileError)
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Veuillez chargée une vidéo de l\'article',style: GoogleFonts.roboto(fontSize:11,color: Colors.red),)),
                if(selectedFile!=null)
                FileSelectedViewer(file: selectedFile!, onClose: onClose,type: 'video',)
              ],
            ),
            if(responseShow)
            Container(
              margin:const EdgeInsets.only(top: 16),
              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(36)
              ),
              child: Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 18,),
                  Icon(responseType==1? Icons.check:Icons.warning),
                  const SizedBox(width: 22,),
                  Text(responseMessage,style: GoogleFonts.roboto(fontWeight: FontWeight.w500),),
                ],
              )),
            ),
            Container(
              height: 46,
              margin:const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: linearGradient, 
                borderRadius: BorderRadius.circular(36)
              ),
              child: Center(
                child: TextButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      if(selectedFile!=null){
                        vendre();
                      }
                      else{
                        setState(() {
                          fileError=true;
                        });
                      }
                    }
                  },
                  // style: TextButton.styleFrom(),
                  child:waitSale?const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1,),): Text("METTRE EN VENTE",style: GoogleFonts.roboto(fontSize:14,color: Colors.white),)),
              )
            ), 
            
          ],
        ),
      )
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
                    Container(
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

  Column textFormField(
    {
      required String label, 
      required String hint, 
      required TextEditingController controller,
      required bool requiet, 
      required String type
    }
  ) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 38,
              margin:const EdgeInsets.symmetric(vertical: 8),
              child:SizedBox(
                // height: 45,
                child: TextFormField(
                controller: controller,
                validator: (value){
                  if(requiet){
                    if(value==null || value.isEmpty){
                      return 'Champ obligatoire';
                    }
                  }
                  return null;
                },
                keyboardType:type!='number'? TextInputType.text:TextInputType.number,
                  style: GoogleFonts.roboto(fontSize:12),
                  decoration: InputDecoration(
                    
                    label: Text(label,style: GoogleFonts.roboto(fontSize: 12),),
                    hintText: hint, 
                    hintStyle: GoogleFonts.roboto(fontSize:13),
                    contentPadding:const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide:const BorderSide(
                        width: 1, 
                        color: Colors.black12
                      )
                    ), 
                    enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide:const BorderSide(
                        width: 1, 
                        color: Colors.black12
                      )
                    )
                  ),
                ),
              )
            ),
          ],
        );
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

  loadFile(){
    choiceFile('video');
  }


  vendre(){
    Map data={
      'content':texte.text, 
      'price':double.parse(prix.text), 
      'type':'sale', 
      'name':nomArticle.text, 
      'quantity':int.parse(qte.text), 
      'user':DataController.user!.id, 
      'devise':devise.text
    };
    setState(() {
      waitSale=true;
    });
    PublicationService.addVente(selectedFile!, data).then((value){
      setState(() {
        waitSale=false;
      });
      if(value!.statusCode==200){
        setState(() {
          responseShow=true;
          responseMessage="Article publié";
          responseType=1;
          texte.text='';
          nomArticle.text='';
          prix.text='';
          qte.text='';
          devise.text='';
        });
        Future.delayed(const Duration(milliseconds: 800),(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageTab() ));
                        });
        Future.delayed(Duration(seconds: 2),(){
          setState(() {
            responseShow=false;
          });
          Navigator.pop(context);
        });
        
      }
      else{
        setState(() {
          responseShow=true;
          responseMessage="Erreur de publication";
          responseType=2;
        });
      }
      print("status Code :${value.statusCode}");
    }).catchError((e){
      setState(() {
        waitSale=false;
      });
      setState(() {
          responseShow=true;
          responseMessage="Erreur de publication";
          responseType=2;
        });
      print("ERORRRRRR $e");
    });
  }
 
}