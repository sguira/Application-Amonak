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
  final bool? hideLabel;
  const BoutiquePage({super.key,this.hideLabel});

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

  TextEditingController search=TextEditingController();

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

  Widget header(dynamic setState_) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.red
      // ),
      // height: 8,
      // margin: EdgeInsets.only(top: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,  
        children: [
          // if(widget.hideLabel!=null&&widget.hideLabel==true)
          Container(
            margin:const EdgeInsets.symmetric(vertical: 18),
            child: Text("\" NOUS DEVENONS CE QUE NOUS PENSONS \"",style: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.w700),),
          ), 
          Container(
            width: 280,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22)
            ),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                hintText: 'Chercher..',
                hintStyle: GoogleFonts.roboto(fontSize: 12),
                contentPadding:const EdgeInsets.symmetric(vertical: 4,horizontal: 18),
                border:const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0, color: Colors.transparent, 
                  )
                ), 
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide:const BorderSide(
                    width: 0, color: Colors.transparent, 
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide:const BorderSide(
                    width: 0, color: Colors.transparent, 
                  )
                )
              ),
              onChanged: (value){
                if(value.length>=3){
                  UserService.getBoutique(search: search.text).then((value){
                    print("values status code search:${value.statusCode}");
                    if(value.statusCode==200){
                      setState_(() {
                          boutiques=[];
                          for(var item in jsonDecode(value.body) as List){
                            boutiques.add(User.fromJson(item));
                          }
                        });
                    }
                  }).catchError((e){
                    print("Error $e");
                    UserService.getBoutique().then((value){
                      if(value.statusCode==200){
                        setState_(() {
                          boutiques=[];
                          for(var item in jsonDecode(value.body) as List){
                            boutiques.add(User.fromJson(item));
                          }
                        });
                      }
                    });
                  });
                }
                else{
                  UserService.getBoutique().then((value){
                      if(value.statusCode==200){
                        setState_(() {
                          boutiques=[];
                          for(var item in jsonDecode(value.body) as List){
                            boutiques.add(User.fromJson(item));
                          }
                        });
                      }
                    });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Container pageContainer(BuildContext context) {
    return Container(
    margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 22),
    child: StatefulBuilder(
      builder: (context,setState_) {
        return NestedScrollView(

          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 100,
                floating: true,
                // pinned: true,
                // collapsedHeight: 50,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: header(setState_),
                  
                ),
              ), 
              
              
            ];
          },
        
          
            
           body: ListView.builder(
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
    ),
  );
  }

  

  

  

  
}