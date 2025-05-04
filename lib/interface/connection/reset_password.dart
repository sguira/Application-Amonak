import 'package:application_amonak/interface/connection/change_password.dart';
import 'package:application_amonak/interface/connection/confirm_change.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
class ResetPassword extends StatefulWidget {
 
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final formKey=GlobalKey<FormState>();
  bool waitRequest=false;

  // final formKey=GlobalKey<FormState>();
  // bool waitRequest=false;
  TextEditingController email=TextEditingController();
  String label="Votre adresse mail";
  String description="Veuillez entrer votre adresse email et un code vous sera envoyer pour changer votre mot de passe et accéder à votre compte Amonak.";
  String hint="Email..";
  String titre="Réinitialiser votre mot de passe";
  bool waitRequestReset=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
      height: 370,
      child: ListView(
        children: [
          Container(
            margin:const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 12),
                      child: Text(titre,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize:15),),
                    ),
                    SizedBox(
                      width: ScreenSize.width*0.86,
                      child: Text(description,style: GoogleFonts.roboto(fontSize: 13),)
                    )
                    
                  ],
                ), 
                // Container(
                //   margin:const EdgeInsets.symmetric(vertical: 16),
                //   child: IconButton(onPressed: (){
                //     Navigator.pop(context);
                //   }, icon:const Icon(Icons.close)))
              ],
            ),
          ), 
          // SizedBox(height: 22,),
          Container(
            margin:const EdgeInsets.only(top: 6),
            child: Form( 
              key: formKey,
              child: Column(
                children: [
                   Container(
                    margin:const EdgeInsets.symmetric(horizontal: 6),
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,style: GoogleFonts.roboto(fontSize: 12,letterSpacing: 0.8,color: Colors.black.withAlpha(150)),),
                          const SizedBox(height: 6,),
                          TextFormField(
                            controller: email,
                            validator: (value){
                              
                                if(!EmailValidator.validate(value!)){
                                  return 'email invalide';
                                }
                              
                              if(value.isEmpty){
                                return 'Champ obligatoire';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              // label: Text()
                              // border:const OutlineInputBorder(
                              //   borderSide: BorderSide(width: 2)
                              // ), 
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 2,color: Colors.black.withAlpha(180)), 
                                // borderRadius: BorderRadius.circular(8)
                              ), 
                              hintText: hint, 
                              hintStyle: GoogleFonts.roboto(fontSize: 13)
                            ),
                          ),
                        ],
                      ),
                   ),
                   
                  Container(
                    margin:const EdgeInsets.symmetric(vertical: 18),
                    padding:const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      gradient: linearGradient, 
                      borderRadius: BorderRadius.circular(36)
                    ),
                    child: Center(
                      child:buttonAction((){}, 'Confirmer') ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TextButton buttonAction( Function onPressed, String btnTexte) {
    return TextButton(onPressed: (){
      if(formKey.currentState!.validate()){
        gotoConfirmCode();
      }
    }, child:waitRequestReset==false? Text(btnTexte.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),):const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),));
  }


  gotoConfirmCode()async{
    setState(() {
      waitRequest=true;
    });
    Login.requestResetPassword(email.text).then((value) {
      print("Reset status code: ${value.statusCode}");
      setState(() {
        waitRequest=false;
      });
      if(value.statusCode==200){
        Navigator.pop(context);
        showCustomModalSheetWidget(context: context, child:const ConfirmChange());
      }
    }).catchError((e){
      setState(() {
        waitRequest=true;
      });
    });
    
    // await Future.delayed(Duration(seconds: 5));
    
  }
  
}