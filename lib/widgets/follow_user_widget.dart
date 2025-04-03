
import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


bool isFriend(String id){
  for(var friend in DataController.friends){
    if(friend.id==id){
      return true;
    }

  }
  return false;
}

Container FollowUserWidget(BuildContext context, User user) {
    return Container(
            margin:const EdgeInsets.symmetric(horizontal: 1,vertical: 12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: user) ));
                  },
                  child: Container(
                    width: 68, 
                    height: 68, 
                    // padding:const EdgeInsets.all(4), 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(86), 
                      color: Colors.black12
                    ),
                    child: ClipOval(child:user.avatar!.isNotEmpty? Image.network(user.avatar![0].url!,fit: BoxFit.cover,):Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,)),
                  ),
                ),
                
                Container(
                  alignment: Alignment.center,
                  width: 80,
                  margin:const EdgeInsets.symmetric(vertical: 4),
                  child: Text(user.userName.toString().toUpperCase(),style: GoogleFonts.roboto(fontSize: 11,fontWeight: FontWeight.w600,letterSpacing: 1.2),overflow: TextOverflow.ellipsis,)),
                !isFriend(user.id!)?
                TextButton(
                  onPressed: (){
                    UserService.sendFriend(user.id!).then((value) {
                      print('Friend request sent $value');
                      if(value=='OK'){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invitaion envoyée ")));
                        // DataController.
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
                ): Container(
                  padding: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                  decoration: BoxDecoration(
                    // color: Colors.black12, 
                    borderRadius: BorderRadius.circular(22)
                  ),
                  child:Wrap(
                  children: [
                    Icon(Icons.check,size: 18,),Text("Abonné",style: GoogleFonts.roboto(fontSize: 13),)
                  ],
                ),
                )
              ],
            ),
          );
  }