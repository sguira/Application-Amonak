import 'dart:convert';

import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentaireButton extends StatefulWidget {
  final String pubId;
  final Color? color;
  final dynamic pub;
  const CommentaireButton({super.key,required this.pubId,this.color,required this.pub});

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
    await CommentaireService.getCommentByPublication(pubId: widget.pubId).then((value){
      if(value.statusCode.toString()=='200'){
        setState(() {
          nbComments=(jsonDecode(value.body) as List).length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
                  // margin:const EdgeInsets.symmetric(vertical: 18),
                  height: 80,
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        showModalBottomSheet(context: context,
                        isScrollControlled: true,
                         builder:(context)=> SizedBox(
                          height: 650,
                          child: CommentaireWidget(pubId: widget.pubId,pub: widget.pub )));
                      }, icon: Icon(Icons.comment,color:widget.color)),
                      Text(NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: '').format(nbComments),style: GoogleFonts.roboto(color:widget.color),)
                    ],
                  ));
  }
}