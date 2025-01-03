

import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class WaitWidget extends StatelessWidget {
  final String? label;
  const WaitWidget({super.key,this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2, color: couleurPrincipale,
          ),
          if(label!=null)
          Container(
            child: Text(label!,style: GoogleFonts.roboto(),),
          )
        ],
      ),
    );
  }
}