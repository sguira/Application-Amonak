import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/widgets/follow_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_amonak/models/user.dart';
class ListePersonnePage extends StatefulWidget {
  // TextEditingController?  controller;
  const ListePersonnePage({super.key});

  @override
  State<ListePersonnePage> createState() => _ListePersonnePageState();
}

class _ListePersonnePageState extends State<ListePersonnePage> {

  List<User> users=[];

  TextEditingController search=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Valeur de la réquête ${widget.query}");
    // if(widget.controller!=null){
    //   widget.controller!.addListener(() {
    //     if(widget.controller!.text.length>2){
    //       print("la taille depasse 2");
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService.getAllUser().then((value)=>{
        print('valeur ret²ourné\n\n'),
        print(value.statusCode),
        if(value.statusCode==200){
            users=[],
            for(var user in jsonDecode(value.body)as List){
              users.add(User.fromJson(user))
            }
          
        }
      }).catchError((e){
        print(e);
      }),
      builder: (context,snashot) {
        if(snashot.hasError){
          return Center(
            child: Text("Veriviez votre Connexion",style: GoogleFonts.roboto(),),
          );
        }
        if(snashot.hasData){
          return  StatefulBuilder(
            builder: (context,setState_) {
              return Container(
                margin:const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      header(setState_),
                      for(var item in users)
                      if(DataController.user!.id!=item.id!)
                      FollowUserWidget(context,item)
                    ],
                  ),
                ),
              );
            }
          );
        }
        return const Center(
          child: CircularProgressIndicator(

          ),
        );
      }
    );
  }

   header(dynamic setState_) {
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
                  UserService.searchUser(search.text).then((value){
                    print("values status code search:${value.statusCode}");
                    if(value.statusCode==200){
                      setState_(() {
                          users=[];
                          for(var item in jsonDecode(value.body) as List){
                            users.add(User.fromJson(item));
                          }
                        });
                    }
                  }).catchError((e){
                    print("Error $e");
                    UserService.getAllUser().then((value){
                      if(value.statusCode==200){
                        setState_(() {
                          users=[];
                          for(var item in jsonDecode(value.body) as List){
                            users.add(User.fromJson(item));
                          }
                        });
                      }
                    });
                  });
                }
                else{
                  UserService.getAllUser().then((value){
                      if(value.statusCode==200){
                        setState_(() {
                          users=[];
                          for(var item in jsonDecode(value.body) as List){
                            users.add(User.fromJson(item));
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

  
}