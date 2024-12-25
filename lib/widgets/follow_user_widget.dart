
import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

Container FollowUserWidget(BuildContext context, User user) {
    return Container(
            margin:const EdgeInsets.symmetric(horizontal: 8,vertical: 26),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: user) ));
                  },
                  child: Container(
                    width: 80, 
                    height: 80, 
                    // padding:const EdgeInsets.all(4), 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(86), 
                      color: Colors.black12
                    ),
                    child: ClipOval(child:user.avatar!.isNotEmpty? Image.network(user.avatar![0].url!,fit: BoxFit.cover,):Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,)),
                  ),
                ),
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 4),
                  child: Text(user.userName.toString().toUpperCase(),style: GoogleFonts.roboto(fontSize: 11,fontWeight: FontWeight.w600,letterSpacing: 1.2),)), 
                TextButton(
                  onPressed: (){
                    UserService.sendFriend(user.id!).then((value) {
                      print('Friend request sent $value');
                      if(value=='OK'){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invitaion envoyée ")));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur lors de")));
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:couleurPrincipale.withAlpha(40), 
                    padding:const EdgeInsets.symmetric(horizontal: 18)
                  ),
                  child: Text("S'abonner",style:GoogleFonts.roboto(fontSize: 11))
                )
              ],
            ),
          );
  }