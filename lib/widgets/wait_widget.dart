

import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          const SpinKitWaveSpinner(color: couleurPrincipale),
          if(label!=null)
          Container(
            child: Text(label!,style: GoogleFonts.roboto(),),
          )
        ],
      ),
    );
  }
}