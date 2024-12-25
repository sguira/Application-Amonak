import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextEditingController content=TextEditingController();
final keyForm=GlobalKey<FormState>();

Future<dynamic> zoneCommentaire(BuildContext context,Publication pub,String pubId) {
    
    return showModalBottomSheet(context: context,isScrollControlled: true, builder: (context,){
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: ScreenSize.height*0.88
                    ),
                    child: Column(
                      children: [
                        headerBottomSheet(context, "Commentaires"),
                         Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for(Commentaire com in pub.commentaires) 
                                Container(
                                  width: ScreenSize.width*0.8,
                                  padding:const EdgeInsets.all(4), 
                                  margin:const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                    border:Border.all(width: 2,color: couleurPrincipale), 
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(com.content!)
                                )
                              ],
                            ),
                          )
                        ), 
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
                          child: Form(
                            key: keyForm,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: 48,
                                    child: TextFormField(
                                      maxLines: null,
                                      controller: content, 
                                      validator: (value){
                                        if(value!.isEmpty) return "Veuillez entrer un commentaire";
                                        return null;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        contentPadding:const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                        hintText: 'Votre commentaire', 
                                        hintStyle: GoogleFonts.roboto(fontSize:12),
                                        isCollapsed: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                      ),
                                    ),
                                  )
                                ), 
                                Container(
                                  padding:const EdgeInsets.all(4),
                                  child: TextButton(
                                    
                                    onPressed: (){
                                      if(keyForm.currentState!.validate()){
                                        ajouterCommentaire();
                                      }
                                    }, child: Column(
                                    children: [
                                      const Icon(Icons.send),
                                      Text('Commenter',style: GoogleFonts.roboto(fontSize: 7),)
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
  }

  ajouterCommentaire(){
    Commentaire com=Commentaire();
    com.content=content.text;
    com.userId=DataController.user!.id;
    CommentaireService.saveComent(com).then((value) {
      
    });
  }