import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

 Container multilineTexteForm({
  required TextEditingController controller, 
  required String hint
 }) {
    return Container(
          child: TextFormField(
            controller: controller,
            validator: (value){
              if(value!.isEmpty){
                return 'Veuillez saisir un texte';
              }
            },
            maxLines: 5,
            style: GoogleFonts.roboto(fontSize: 13),
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none, 
              hintText: hint, 
              hintStyle: GoogleFonts.roboto(fontSize: 14)
            ),
          ),
        );
  }