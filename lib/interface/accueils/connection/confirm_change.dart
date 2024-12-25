import 'package:application_amonak/interface/accueils/connection/change_password.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
class ConfirmChange extends StatefulWidget {
  
  const ConfirmChange({super.key});

  @override
  State<ConfirmChange> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ConfirmChange> {

  final formKey=GlobalKey<FormState>();
  bool waitRequest=false;
  TextEditingController confirmCode=TextEditingController();
  String label="Code reçu par mail.";
  String description="Veuillez entrer le code à quatre (04) chiffres envoyé par mail.";
  String hint="Code..";
  String titre="Réinitialiser votre mot de passe";
  bool waitRequestReset=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 12,horizontal: 18),
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
                      child: Text(titre,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,letterSpacing: 1),),
                    ),
                    Container(
                      width: ScreenSize.width*0.75,
                      child: Text(description,style: GoogleFonts.roboto(fontSize: 13),)
                    )
                    
                  ],
                ), 
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 16),
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon:const Icon(Icons.close)))
              ],
            ),
          ), 
          // SizedBox(height: 22,),
          Container(
            margin:const EdgeInsets.only(top: 6),
            child: Form( 
              // key: widget.formKey,
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
                            controller: confirmCode,
                            validator: (value){
                              
                               
                              
                              if(value!.isEmpty){
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
                    margin:const EdgeInsets.symmetric(vertical: 26),
                    padding:const EdgeInsets.symmetric(vertical: 6),
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
        setState(() {
          waitRequestReset=true;
        });
        onPressed();
        setState(() {
          waitRequestReset=false;
        });
      }
    }, child:waitRequestReset==false? Text(btnTexte.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),):SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),));
  }

  
}