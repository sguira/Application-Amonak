import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/like.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/like.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
class CommentaireWidget extends StatefulWidget {
  final Publication? publication;
  const CommentaireWidget({super.key,this.publication});

  @override
  State<CommentaireWidget> createState() => _CommentaireWidgetState();
}

class _CommentaireWidgetState extends State<CommentaireWidget> {

  Publication pub=Publication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pub=super.widget.publication!;
    
    print("PUBLICATION ${pub.id}");
  }

  TextEditingController content=TextEditingController();
  final keyForm=GlobalKey<FormState>();
  List<Commentaire> commentaires=[];

  bool waitComment = false;

  @override
  Widget build(BuildContext context) {
    if(pub.id!=null){
    return FutureBuilder(
      future: CommentaireService.getCommentByPublication(pub.id!).then((value){
        print("Status code ${value.statusCode}");
        if(value.statusCode.toString()=='200'){
          commentaires=[];
          for(var map in jsonDecode(value.body) as List){
            commentaires.add(Commentaire.fromJson(map));
          }
          print("Status code ${value.statusCode}");
        }
        }).catchError((e){
          print("Une erreur est survenu $e");
      }),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return zoneCommentaire(pub);
        }
        if(snapshot.hasError){
          return  Container(
            margin:const EdgeInsets.symmetric(vertical: 22,horizontal: 18),
            child:const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Erreur de chargement "),
                ),
              ],
            ),
          );
        }
        return zoneCommentaire(pub);
      }
    );}
    else{
      return Center();
    }
  }

  


  zoneCommentaire(Publication pub,) {
    
    return  Container(
                    width: ScreenSize.height*0.88,
                    child: Column(
                      children: [
                        headerBottomSheet(context, "Commentaires"),
                         Expanded(
                          child:commentaires.isNotEmpty? SingleChildScrollView(
                            child: Column(
                              children: [
                                for(Commentaire com in commentaires) 
                                ItemCommentaire(com: com,)
                                
                              ],
                            ),
                          ):Center(
                            child: Text("Aucun commentaire Trouvé."),
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
                                      style: GoogleFonts.roboto(fontSize:13),
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
                                    
                                    onPressed: ()async{
                                      if(keyForm.currentState!.validate()){
                                        ajouterCommentaire(pub);
                                      }
                                    }, child:waitComment==false? Column(
                                    children: [
                                      const Icon(Icons.send),
                                      Text('Commenter',style: GoogleFonts.roboto(fontSize: 7),)
                                    ],
                                  ):Container(
                                    child:const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,),),
                                  )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                
  }

  Container buttonReatComment(String label,Function onPressed) {
    return Container(
                                                            margin: EdgeInsets.all(6),
                                                            child: GestureDetector(
                                                              onTap: onPressed(),
                                                              child: Row(
                                                              children: [
                                                                Text(label,style: GoogleFonts.roboto(fontSize: 9,fontWeight:FontWeight.w500),),
                                                              ],
                                                            )));
  }

  ajouterCommentaire(Publication pub)async{
    Commentaire com=Commentaire();
    com.content=content.text;
    com.userId=DataController.user!.id;
    com.publicationId=pub.id;
    setState(() {
      waitComment=true;
    });
    CommentaireService.saveComent(com).then((value) {
      setState(() {
        pub.commentaires.add(
          com
        );
        waitComment=false;
      });
    });
    
  }

  isLiked(Commentaire com, String id){ 
    for(Like like in com.likes!){
      if(like.userId==id){
        return true;
      }
    }
    return false;
  }

}

class ItemCommentaire extends StatefulWidget {
  final Commentaire com;
  const ItemCommentaire({super.key,required this.com});

  @override
  State<ItemCommentaire> createState() => _ItemCommentaireState();
}

class _ItemCommentaireState extends State<ItemCommentaire> {

  late bool isLiked=false;

  late Commentaire commentaire;

  String likeId="";

  @override
  void initState() {
    super.initState();
    print("user id ${DataController.user!.id}\n\n\n");
    commentaire=widget.com;
    LikeService.getNombreLike(commentaire.id!).then((value){
      if(value.statusCode==200){
        setState(() {
          commentaire.nbLikes=(jsonDecode(value.body) as List).length;
        });
        
      }
    });

    LikeService.getLikeByUser(commentId: commentaire.id!,userId: DataController.user!.id!).then((value){
      if(value.statusCode==200){
        for(var item in jsonDecode(value.body)){
          if(item['user']==DataController.user!.id){
            setState(() {
              isLiked=true;
              likeId=item['_id'];
              return;
            });
          }
        }
      }
    }).catchError((e){
      return e;
    });
    
    print("Publication Id: ${commentaire.id}");
    print(" nombre like ${commentaire.nbLikes}");
  }

  // getNombreLike(String id)async{

  // }

  likeCommentaire(Commentaire commentaire)async{
    setState(() {
      isLiked=true;
    });
    await LikeService.ajouterLike(commentId:commentaire.id! , userId: DataController.user!.id!).then((value){
      print("status Code ${value.statusCode}");
      setState(() {
        commentaire.nbLikes=commentaire.nbLikes!+1;
        
      });
      if(value.statusCode!=200){
        setState(() {
          commentaire.nbLikes=commentaire.nbLikes!-1;
          isLiked=false;
        //  isLiked(commentaire, DataController.user!.id!);
        });
      }
      if(value.statusCode==200){
        print("body ${value.body}");
        setState(() {
          likeId=jsonDecode(value.body)['_id'];
        });
      }
    }).catchError((e){
       setState(() {
        commentaire.nbLikes=commentaire.nbLikes!+1;
        isLiked=true;
      });
      print("ERROR $e\n\n");
    });
  }

  // getNombreLike()async{
  //   await 
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
                                  width: ScreenSize.width*1,
                                  padding:const EdgeInsets.all(4), 
                                  margin:const EdgeInsets.symmetric(vertical: 6,horizontal: 2),
                                  decoration: BoxDecoration(
                                    // border:Border.all(width: 1,color: Colors.black12), 
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.black12
                                  ),
                                  child: Row(
                                    crossAxisAlignment: 
                                    CrossAxisAlignment.start,
                                    children: [
                                     
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: commentaire.user!) ));
                                        },
                                        child: Container(
                                          width: 46, 
                                          height:46, 
                                          margin:const EdgeInsets.only(right: 12),
                                          child: ClipOval(child:widget.com.avatar!=null? Image.network(widget.com.user!.avatar![0].url!,fit: BoxFit.cover,):Image.asset("assets/medias/user.jpg",fit:BoxFit.cover )),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ScreenSize.width*0.65,
                                            // padding: EdgeInsets.all(8),
                                            
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: ScreenSize.width*0.65,
                                                  constraints: BoxConstraints(
                                                    // maxHeight: 90
                                                  ),
                                                  padding:const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color:Colors.black.withAlpha(20),
                                                    borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(widget.com.user!.userName!,style: GoogleFonts.roboto(fontWeight:FontWeight.w600,fontSize:12),),
                                                      Text(widget.com.content!,style: GoogleFonts.roboto(fontSize:14),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("Il y'a 7min",style: GoogleFonts.roboto(fontSize:9),),
                                                      Spacer(),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                            margin:const EdgeInsets.all(6),
                                                            child: GestureDetector(
                                                              onTap:(){
                                                                // likeCommentaire(com);
                                                              },
                                                              child: Row(
                                                              children: [
                                                                // Text("J'aime",style: GoogleFonts.roboto(fontSize: 9,fontWeight:FontWeight.w500,color: isLiked(com, DataController.user!.id!)?Colors.blue:Colors.black)),
                                                              ],
                                                            ))),
                                                            // buttonReatComment('Repondre',(){}),
                                                          ],
                                                        )
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  Text(NumberFormat.compact().format(widget.com.nbLikes),style: GoogleFonts.roboto(fontSize:10,fontWeight: FontWeight.w600),), 
                                                                  const SizedBox(width: 2,),
                                                                  Text('Likes',style: GoogleFonts.roboto(fontSize: 9),), 
                                                                  
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ) 
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                          
                                        ],
                                      ),
                                    
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(onPressed: (){
                                            if(likeId.isNotEmpty){
                                               setState(() {
                                                  isLiked = false;
                                                  commentaire.nbLikes=commentaire.nbLikes!-1;
                                                });
                                              LikeService.removeLike(likeId).then((value) {
                                                
                                                if(value.statusCode!=200){
                                                  // commentaire.nbLikes=commentaire.nbLikes!-1;
                                                  setState(() {
                                                    isLiked=false;
                                                  });
                                                }
                                                if(value.statusCode==200){
                                                  setState(() {
                                                    likeId='';
                                                  });
                                                }
                                              }).catchError((e){
                                                print("ERROR $e");
                                                setState(() {
                                                  commentaire.nbLikes=commentaire.nbLikes!+1;
                                                  isLiked=true;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verifier votre connexion')));
                                              });
                                            }
                                            else{
                                              setState(() {
                                                likeCommentaire(commentaire);
                                              });
                                            }
                                          }, icon: Icon(isLiked==false? Icons.favorite_border: Icons.favorite_outlined,size: 22,color: isLiked?Colors.red:null,)),
                                        ],
                                      )
                                    ],
                                  )
                                );
  }
}