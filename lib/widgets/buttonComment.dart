import 'dart:convert';

import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentaireButton extends StatefulWidget {
  final String pubId;
  final Color? color;
  const CommentaireButton({super.key,required this.pubId,this.color});

  @override
  State<CommentaireButton> createState() => _CommentaireButtonState();
}

class _CommentaireButtonState extends State<CommentaireButton> {

  int nbComments=0;

  @override
  void initState() {
    super.initState();
    setState(() {
      nombreComment();
    });
  } 

  nombreComment()async{
    await CommentaireService.getCommentByPublication(widget.pubId).then((value){
      if(value.statusCode.toString()=='200'){
        setState(() {
          nbComments=(jsonDecode(value.body) as List).length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
                  // margin:const EdgeInsets.symmetric(vertical: 18),
                  height: 80,
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        showModalBottomSheet(context: context,
                        isScrollControlled: true,
                         builder:(context)=> Container(
                          height: 650,
                          child: CommentaireWidget(pubId: widget.pubId)));
                      }, icon: Icon(Icons.comment,color:widget.color??null)),
                      Text(NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: '').format(nbComments),style: GoogleFonts.roboto(color:widget.color),)
                    ],
                  ));
  }
}