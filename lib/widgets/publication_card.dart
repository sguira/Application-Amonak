import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

Container itemPublication(User item,int style) {
    return Container(
            width: ScreenSize.width*0.9,
            padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 6),
            margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Colors.black26), 
              borderRadius: BorderRadius.circular(11)
            ),
            child: Column(
              children: [
                // style==1?
                headerBoutique2(item,style),
                // textContainer(item)
                Container(
                  width: ScreenSize.width*0.75,
                  margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue, 
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: Image.asset('assets/medias/profile.jpg',fit: BoxFit.cover,),
                ), 
                Container(
                  margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  child: footerPublication(item),
                )
              ],
            ),
          );
  }

footerPublication(dynamic item){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // itemDescription(item['countArticles'], 'Articles'), 
              // itemDescription(item['nbAbonnes'], 'Abonnés'), 
              // itemDescription(item['nbAchats'], 'Achats'),
            ],
          ), 
          TextButton(
            onPressed: (){},
            style: TextButton.styleFrom(
              backgroundColor:const Color.fromRGBO(97, 81, 212, 1), 
              padding:const EdgeInsets.symmetric(horizontal: 12)
            ),
            child: Text("S'Abonner",style:GoogleFonts.roboto(fontSize: 10,color: Colors.white))
          )
        ],
      ),
    );
  }

  itemDescription(String value,String label){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Text(NumberFormat.compact(locale: 'fr', ).format(int.parse(value)),style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: 12),),
          const SizedBox(width: 2,), 
          Text(label,style: GoogleFonts.roboto(fontSize: 9),)
        ],
      ),
    );
  }

  headerBoutique(Publication pub,int style){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42, 
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(86), 
              // color: Colors.black12
            ),
            child: ClipOval(child: Image.asset('assets/medias/profile.jpg',fit: BoxFit.cover,))), 
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pub.user!.userName!,style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w500),),
                  Text("Publié il y'a ${DataController.FormatDate(date: pub.dateCreation!)}",style: GoogleFonts.roboto(fontSize:13,fontStyle:FontStyle.italic),),
                  // style!=1?
                  // Text("1",style: GoogleFonts.roboto(fontSize: 11),):Container(), 
              
                ],
              ),
            ),
            Spacer(),
            Container(
              child: IconButton(onPressed: (){}, icon:const Icon(Icons.more_horiz)),
            )
        ],
      ),
    );
  }

  headerBoutique2(User pub,int style){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42, 
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(86), 
              // color: Colors.black12
            ),
            child: ClipOval(child:pub.avatar!.isEmpty ? Image.asset('assets/medias/profile.jpg',fit: BoxFit.cover,):Image.network(pub.avatar!.first.url!,fit: BoxFit.contain,))), 
            Column(
              children: [
                Text(pub.userName!,style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w500),),
                // Text(DataController.FormatDate(date: pub.))
              ],
            ), 
            Container(
              child: IconButton(onPressed: (){}, icon:const Icon(Icons.more_horiz)),
            )
        ],
      ),
    );
  }