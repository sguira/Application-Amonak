import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container GradientButton({
  required String label, 
  GlobalKey<FormState>? key, 
  VoidCallback? onPressed,
} ) {
     return Container(
                  margin:const EdgeInsets.only(top: 24),
                  width: ScreenSize.width*0.85,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient:const LinearGradient(colors: [
                      Color.fromRGBO(97, 81, 212, 1), 
                      // Color.fromARGB(255, 9, 51, 189),
                      Color.fromRGBO(132, 62, 201, 1)
                    ])
                  ),
                  child: TextButton(
                    onPressed: (){
                      print("click");
                      if(onPressed!=null){
                           onPressed();
                        }
                      // if(key!=null){
                      //   if(key.currentState!.validate()){
                          
                      //   }
                        
                      // }
                    },
                    style: TextButton.styleFrom(
                      // padding:const EdgeInsets.symmetric(vertical: 20)
                    ),
                    child: Text(label,style: GoogleFonts.roboto(color: Colors.white),) 
                  ),
                );
   }

LinearGradient linearGradient=const LinearGradient(colors: [

  Color.fromRGBO(97, 81, 212, 1), 
                      // Color.fromARGB(255, 9, 51, 189),
                      Color.fromRGBO(132, 62, 201, 1)
                    

]);