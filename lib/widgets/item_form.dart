import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container itemForm({
    TextEditingController? controller, 
    required hint, 
    required label, 
    bool? requiet
  }) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 8),
      // height: 42,
          child: TextFormField(
            focusNode: FocusNode(),
            // autofocus: true,
            // cursorHeight: 16,
            obscureText: label=="Mot de passe"?true:false,
            controller:controller,
            validator: (value){
              if(requiet!){
                if(value!.isEmpty){
                  return 'Champ requis';
                }
              }
              return null;
            },
            cursorWidth: 2,
            decoration: InputDecoration(
              hintText: hint, 
              hintStyle: GoogleFonts.roboto(fontSize: 13),
              labelStyle: GoogleFonts.roboto(fontSize:13),
              label: Text(label,style: GoogleFonts.roboto(fontSize:13),),
              contentPadding:const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
              border:const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 6, 
                  color: Colors.black
                )
              ),
              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2, 
                  color: Colors.black
                )
              ),

              
            ),
          ),
        );
  }