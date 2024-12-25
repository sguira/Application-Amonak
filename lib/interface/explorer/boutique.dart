import 'dart:convert';

import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BoutiquePage extends StatefulWidget {
  const BoutiquePage({super.key});

  @override
  State<BoutiquePage> createState() => _BoutiquePageState();
}

class _BoutiquePageState extends State<BoutiquePage> {

  // List<Map<String,String>> boutiques=[
  //   {
  //     'nom':'Boutique 1', 
  //     'type':'Mode', 
  //     'image':'assets/medias/user.jpg', 
  //     'countArticles':'40', 
  //     'nbAbonnes':'40000', 
  //     'nbAchats':'17500', 
  //     'texte':'Bonjour Je ve'
      
  //   }, 
  //   {
  //     'nom':'Boutique 1', 
  //     'type':'Mode', 
  //     'image':'assets/medias/user.jpg', 
  //     'countArticles':'40', 
  //     'nbAbonnes':'40000', 
  //     'nbAchats':'17500', 
  //     'texte':'Bonjour Je ve'
  //   }, 
  //   {
  //     'nom':'Boutique 1', 
  //     'type':'Mode', 
  //     'image':'assets/medias/user.jpg', 
  //     'countArticles':'40', 
  //     'nbAbonnes':'40000', 
  //     'nbAchats':'17500', 
  //     'texte':'Bonjour Je ve'
  //   }
  // ];

  List<User> boutiques=[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService.getBoutique().then((value){
        if(value.statusCode.toString()=='200'){
          for(var item in jsonDecode(value.body)){
            boutiques.add(User.fromJson(item));
          }
        }
      }),
      builder: (context, snapshot ){
        if(snapshot.connectionState==ConnectionState.waiting){
          return WaitWidget();
        }
        if(snapshot.hasError){
          return const Text("Une erreur est survenue");
        }
        return pageContainer(context);
      }
    );
    
    
  }

  Container pageContainer(BuildContext context) {
    return Container(
    margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 22),
    child: ListView.builder(
      itemCount: boutiques.length,
      itemBuilder: (context,index){
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsBoutique(userid: boutiques[index].id!,user: boutiques[index],) ));
          },
          child: itemPublication(boutiques[index],2));
      },
      
    ),
  );
  }

  

  

  

  
}