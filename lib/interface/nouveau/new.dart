import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/nouveau/add_publication.dart';
import 'package:application_amonak/interface/nouveau/add_vendeur.dart';
import 'package:application_amonak/interface/nouveau/create_alerte.dart';
import 'package:application_amonak/interface/nouveau/vendre_article.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: couleurPrincipale,
      body: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Voir nouveau",style: GoogleFonts.roboto(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.start,),
                Text("Voir loin",style: GoogleFonts.roboto(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.start,),
                if(DataController.user!.accountType!='seller')
                Container(
                  child: Row(
                    children: [
                      itemButtonWithIcon(label: 'Dévenez Vendeur',function: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const BecomeSeller() ));
                      }),
                    ],
                  )
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    itemButtonWithIcon(label: 'Faire une alerte',icon: Icons.add_alert,function: bottomSheetAlerte),
                    itemButtonWithIcon(label: 'Vendre en live',icon: Icons.favorite,function:(){}),
                    itemButtonWithIcon(label: 'Faire une publication',icon: Icons.edit,function: bottomSheetPublication),
                    itemButtonWithIcon(label: 'Vendre un article',icon: Icons.shopping_cart,function: vendreArticle),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  vendreArticle(){
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context)=>const VendreArticle() 
    );
  }

  itemButtonWithIcon({
    required String label, 
    IconData? icon, 
    required Function function
  }) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
                      onPressed: (){
                        function();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white, 
                        padding:const EdgeInsets.symmetric(horizontal: 18,vertical: 12)
                      ),
                      child:Row(
                        children: [
                          if(icon!=null)
                          Icon(icon),
                          const SizedBox(width: 4,),
                          Text(label,style: GoogleFonts.roboto(fontSize: 14),),
                        ],
                      )
                    ),
    );
  }

  bottomSheetAlerte(){
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
      return Container(
        constraints: BoxConstraints(
          maxHeight: ScreenSize.height*0.8
        ),
        child:const CreateAlertePage(),
      );
    });
  }

  bottomSheetPublication(){
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
      return Container(
        constraints: BoxConstraints(
          maxHeight: ScreenSize.height*0.7
        ),
        child:const CreatePublication()
      );
    });
  }
}