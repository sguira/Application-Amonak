import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
successSnackBar(
  {
    required String message, 
    required BuildContext context
  }
){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: GoogleFonts.roboto(),),backgroundColor: Colors.green,));
  
}

errorSnackBar(
  {
    required String message, 
    required BuildContext context
  }
){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style: GoogleFonts.roboto(),),backgroundColor: Colors.red,));
  
}