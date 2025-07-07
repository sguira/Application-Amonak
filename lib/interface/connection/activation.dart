import 'dart:convert';

import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmCodeActivation extends StatefulWidget {
  final String email;
  const ConfirmCodeActivation({super.key,required this.email});

  @override
  State<ConfirmCodeActivation> createState() => _ConfirmCodeActivationState();
}

class _ConfirmCodeActivationState extends State<ConfirmCodeActivation> {

  TextEditingController code=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isWailt=false;
  bool waitResend=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            headerBottomSheet(context, "Activation de Compte"), 
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text("Entrez le compte réçu par mail pour confirmer votre identité avant de pouvoir vous connecter.",style: GoogleFonts.roboto(),),
            ), 
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Code de confirmation",style: GoogleFonts.roboto(fontWeight:FontWeight.w600),), 
                  TextFormField(
                    controller: code,
                    validator: (value){
                      if(value!.length<3){
                        return 'code trop court';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Entrez le code de confirmation',
                      hintStyle: GoogleFonts.roboto(fontSize:12),
                      enabledBorder:const UnderlineInputBorder(
                        borderSide: BorderSide(width: 2)
                      )
                    ),
                  )
                ],
              ),
            ), 
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: linearGradient
              ),
              child: TextButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    isWailt=true;
                  });
                  Login.activateAccount(code.text).then((value) {
                    setState(() {
                      isWailt=false;
                    });
                    if(value.statusCode==200){
                      LocalStorage.saveToken(jsonDecode(value.body)['accessToken'] as String).then((value){
                                                print("\n\n\n valeur retour $value \n\n");
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageTab()));
                                              });
                    }
                    print("value ${value.body}");
                  }).catchError((e){
                    setState(() {
                      isWailt=false;
                    });
                  });
                  
                }
              }, child:isWailt==false? Text("Confirmation",style: GoogleFonts.roboto(color:Colors.white)):const ButtonProgress()),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
              decoration: BoxDecoration(
                gradient: linearGradient,
                borderRadius: BorderRadius.circular(26)
              ),
              child: TextButton(onPressed: (){
                setState(() {
                  waitResend=true;
                });
                Login.resendCode(widget.email).then((value) {
                  setState(() {
                    waitResend=false;
                  });
                  print(value.statusCode);
                }).catchError((e){
                  setState(() {
                  waitResend=false;
                });
                });
              }, child:waitResend==false? Text("Renvoyer le code",style: GoogleFonts.roboto(color:Colors.white),):const ButtonProgress()),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonProgress extends StatelessWidget {
  final Color? color_;
  const ButtonProgress({
    super.key,this.color_
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: 18,width: 18,child: CircularProgressIndicator(strokeWidth: 2,color:color_ != null? Colors.white:color_),);
  }
}