import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/widgets/follow_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_amonak/models/user.dart';
class ListePersonnePage extends StatefulWidget {
  const ListePersonnePage({super.key});

  @override
  State<ListePersonnePage> createState() => _ListePersonnePageState();
}

class _ListePersonnePageState extends State<ListePersonnePage> {

  List<User> users=[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService.getAllUser().then((value)=>{
        print('valeur retourné\n\n'),
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
          return  Container(
            margin:const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  for(var item in users)
                  if(DataController.user!.id!=item.id!)
                  FollowUserWidget(context,item)
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(

          ),
        );
      }
    );
  }

  
}