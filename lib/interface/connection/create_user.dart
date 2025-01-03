import 'dart:io';

import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/models/adresse.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/register.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';



class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final keyCreate=GlobalKey<FormState>();

  bool waitRegister=false;

  TextEditingController nom=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController secteur=TextEditingController();
  TextEditingController adresse=TextEditingController();

  XFile? file;
  File? selectedFile;
  final ImagePicker _picker = ImagePicker();

  bool showErrorR=false;
  String messageR="";
  int type=0;

  // final keyCreate=GlobalKey<FormState>();

  List<Map<String,String>> activityItem=[
    {
      'value':'Nature', 
      'label':'Nature'
    },
    {
      'value':'Media', 
      'label':'Media'
    },
    {
      'value':'Restaurant', 
      'label':'Restaurant'
    },
    {
      'value':'Sport', 
      'label':'Sport'
    },
    {
      'value':'AgroAlimentaire', 
      'label':'AgroAlientaire'
    },
    {
      'value':'Aniaux', 
      'label':'Animaux'
    },
    {
      'value':'Beauté', 
      'label':'Beauté'
    },
    {
      'value':'Entreprise individuelle', 
      'label':'Entreprise individuelle'
    },
    {
      'value':'Services Aux Entreprises', 
      'label':'Services Aux Entreprises'
    },
    {
      'value':'Automobile', 
      'label':'Automobile'
    },
    {
      'value':'Cinema', 
      'label':'Cinema'
    },
    {
      'value':'Mode', 
      'label':'Mode'
    },
    {
      'value':'Jeux et divertissements', 
      'label':'Jeux et divertissements'
    },
    {
      'value':'Santé et bien être', 
      'label':'Santé et bien être'
    },
    {
      'value':'Electroménager', 
      'label':'Electroménager'
    },
    {
      'value':'Immobilier', 
      'label':'Immobilier'
    },
    {
      'value':'Informatique et technologie', 
      'label':'INformatique et technologie'
    },
    {
      'value':'Décoration interieur', 
      'label':'Décoration interieur'
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return bottomSheetContainer();
  }


  bottomSheetContainer() {
     
     return 
        Container(
          decoration:const BoxDecoration(
            // color: Colors.white
          ),
            height: ScreenSize.height*0.9,
            padding:const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    
                    margin: EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Spacer(flex: 3,),
                        Text("S'inscrire",style: GoogleFonts.roboto(fontWeight: FontWeight.w800,fontSize:18),), 
                        Spacer(flex: 2,),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon:const Icon(Icons.close)),
                        // Spacer(),
                        // Spacer(flex: 1,)
                      ],
                    ),
                  ), 
                  const SizedBox(height: 18,),
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                    child:  Text(
                      "Apprêtez vous à entrez dans un univers où vous êtes le véritable patron.",textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(),
                    ),
                  ), 
                  Container(
                    child: Form(
                      key: keyCreate,
                      child: Column(
                        children: [
                          itemTextFieldText(label: 'Votre Nom ou celui de votre boutique', hint: 'Ex. Paul / MK Store', controller: nom,validator: simpleValidator), 
                          itemTextFieldText(label: 'Votre adresse mail', hint: 'Ex. monemail@gmail.com', controller: email,validator: simpleValidator), 
                          itemTextFieldText(label: 'Votre mot de passe', hint: '', controller: password,type: "password",validator: passwordValidator),
                          itemSelectForm(controller: secteur, label: "Votre secteur d'activité", hint: 'Mode'), 
                          itemAdresseField(label: 'Votre adresse ou celle de votre boutique ', hint:  'Choisir'),
                          StatefulBuilder(
                            builder: (context,setState_) {
                              return Container(
                                margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Choisissez une photo de profil',style: GoogleFonts.roboto(fontSize:14),), 
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Accéder aux photos',
                                        enabledBorder:const UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2)
                                        ),
                                        hintStyle: GoogleFonts.roboto(color:Colors.black,fontSize:13), 
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                          choiceImage();
                                        }, icon:const Icon(Icons.photo,size: 18,))
                                      ),
                                      onTap: (){
                                        choiceImage();
                                      },
                                    ),

                                    if(selectedFile!=null)
                                    Column(
                                      children: [
                                        const SizedBox(height: 8,),
                                        FileSelectedViewer(file: selectedFile!, onClose: onCloseFile),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                          Container(
                            margin:const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("En validant ce formulaire vous acceptez nos conditions d'utilisation et notre politique de confidentialité.",style: GoogleFonts.roboto(fontSize: 11),),
                          ), 
                          
                        ],
                      ),
                    ),
                  ),
                  if(showErrorR==true)
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                            color:type==2? Colors.red:const Color.fromARGB(255, 45, 135, 48)
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 28),
                          padding:const EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: Text(messageR,style: GoogleFonts.roboto(color: Colors.white,fontSize: 12),softWrap: true, overflow: TextOverflow.clip,),
                        ), 
                         IconButton(onPressed: (){
                          setState(() {
                            showErrorR=false;
                          });
                         }, icon:const Icon(Icons.close,color: Colors.white,))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenSize.width*0.80,
                        constraints:const BoxConstraints(
                          // maxWidth: 300
                        ),
                        margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          gradient:const LinearGradient(
                            colors:[
                              Color.fromRGBO(97, 81, 212, 1), 
                          // Color.fromARGB(255, 9, 51, 189),
                             Color.fromRGBO(132, 62, 201, 1)
                            ]
                          )
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              if(keyCreate.currentState!.validate()){
                                onCreateUser();
                              }
                            },
                            child: Center(
                              child:waitRegister==false? Center(child: Text("S'inscrire",style:GoogleFonts.roboto(color: Colors.white))):const SizedBox(
                                width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.5,color: Colors.white,),
                              ),
                            )
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
                );
       
     
   }

    choiceImage()async{
    file=await _picker.pickImage(source: ImageSource.gallery);

    if(file!=null){
      
        setState(() {
          selectedFile=File(file!.path);
        });
      
    }
  }

  onCloseFile(){
    setState(() {
      selectedFile=null;
    });
  }

  passwordValidator(String? value){
    if(value!.length<6){
      return 'Au moins 6 caractères';
    }
    return null;
  }

   itemTextFieldText({
    required label, 
    required hint, 
    required controller, 
    String? type="text", 
    required Function validator
  }){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      // height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.roboto(
            fontSize: 13
          ),),
          TextFormField(
            controller: controller,
            validator: (value)=>validator(value),
            obscureText: type=="password"?true:false, 
            decoration: InputDecoration(
              // label: Text(label,style: GoogleFonts.roboto(fontSize: 12),),
              hintText: hint, 
              hintStyle: GoogleFonts.roboto(color: Colors.black45,fontSize: 12), 
              border:const UnderlineInputBorder(
                borderSide: BorderSide(width: 4)
              ), 

              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5)
              )
            ),
          ),
        ],
      ),
    );
  }

  simpleValidator(String? value){
    print("validator invoke $value");
    if(value!.isEmpty){
      return 'Champ obligatoire';
    }
    return null;
  }

  passValidator(){
    return null;
  }

  itemAdresseField(
    {
      required label,
      required hint
    }
  ){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(label,style: GoogleFonts.roboto(fontSize: 11)),
          
          Container(
            margin:const EdgeInsets.symmetric(vertical: 4),
            height: 58,
            child:TextFormField(
              decoration: InputDecoration(
                hintText: hint, 
                border:const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5
                  )
                )
              ),
            )
          ),
        ],
      ),
    );
  }

  itemSelectForm({
    required TextEditingController controller, 
    required label, 
    required hint, 
    
  }){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.roboto(fontSize: 11),),
          Container(
            child: SelectFormField(
              controller: controller,
              validator: (value){
                if(value!.isEmpty){
                  return 'Champ obligatoire';
                }
                return null;
              }, 
              decoration: InputDecoration(
                hintText: hint, 
                hintStyle: GoogleFonts.roboto(fontSize: 12)
              ),
              dialogSearchHint: 'Chercher',
              enableSearch: true, 
              style: GoogleFonts.roboto(),
              type: SelectFormFieldType.dialog,
              items: [ 
                for(var item in activityItem)

                item
               ],
              
              onChanged: (value){
                setState(() {
                  controller.text=value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  onCreateUser(){
    showErrorR=false;
    setState((){
      waitRegister=true;
    });
    User user=User();
    user.email=email.text;
    user.password=password.text;
    user.userName=nom.text;
    Address adress=Address(countryCode: '225',state: 'CI',city:adresse.text);
    // user.address!.add(adress);
    // user.
    print(" Email: ${user.email}\n\n ${user.userName}");
    print("passWord ${user.password} \n\n");
    Register.createUser(user: user,picture: selectedFile).then((value){
      print("\n\n Value retourné: $value");
      setState((){
        waitRegister=false;
      });
      print("\n\n Value retourné: $value");
      if(value=='ERROR'){
        setState((){
         showErrorR=true;
         messageR="Un problème est survenue";
         type=2;
        });
      }
      else{
        showErrorR=true;
        messageR="Votre compte est crée veuillez confirmer par mail";
        type=1;
      }
    }).catchError((e){
      print(e);
      setState((){
        waitRegister=false;
      });
    });
  }
}