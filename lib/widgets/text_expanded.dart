import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextExpanded extends StatefulWidget {
  final String texte;
  const TextExpanded({super.key,required this.texte});

  @override
  State<TextExpanded> createState() => _TextExpandedState();
}

class _TextExpandedState extends State<TextExpanded> {
  bool isExpanded=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
      
      decoration: BoxDecoration(
        // color: Colors.black.withAlpha(80), 
        borderRadius: BorderRadius.circular(4)
      ),
      width: ScreenSize.width*0.75,
      constraints:BoxConstraints(maxHeight:isExpanded==false? 130:ScreenSize.height*0.6),
      child:widget.texte.length>100? SingleChildScrollView(
        child: Text.rich(
          
          TextSpan(
            
            children: [
              TextSpan(
                text: isExpanded==false? widget.texte.substring(0,100):widget.texte, 
                style: GoogleFonts.roboto(color:Colors.black,letterSpacing:1,fontWeight:FontWeight.w400 )
              ), 
              TextSpan(
                text:isExpanded==false? " voir plus...":"voir moins",
                style: GoogleFonts.roboto(color:Colors.black,fontWeight:FontWeight.bold, fontSize:16),
                recognizer: TapGestureRecognizer(
                  
                )..onTap=(){
                  setState(() {
                    isExpanded=!isExpanded;
                  });
                }
              )
            ]
          )
        ),
      ):Text(widget.texte,style: GoogleFonts.roboto(),)
    );
  }
}