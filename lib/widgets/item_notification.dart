import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ItemNotification extends StatefulWidget {
  final NotificationModel notification;
  const ItemNotification({super.key,required this.notification});

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.notification.action=="users"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: widget.notification.data) ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xF5F5F51), 
          borderRadius: BorderRadius.circular(7)
        ),
        margin:const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
        padding:const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 43, 
                  height: 47,
                  padding: EdgeInsets.all(8),
                  
                  decoration: BoxDecoration(
                    color: couleurPrincipale.withAlpha(40), 
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Center(
                    child: Text(widget.notification.from!.userName![0],style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500,color: couleurPrincipale),))), 
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          decoration:const BoxDecoration(
                            // color: Colors.red
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: widget.notification.from!.userName,style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.bold)),
                                TextSpan(text: '\t',style: GoogleFonts.roboto()),
                                TextSpan(text: widget.notification.content,style: GoogleFonts.roboto(fontSize: 12))
                              ]
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:3 ),
                              child: Text("il y'a environ ${DataController.FormatDate(date: widget.notification.createAt!)} ",style: GoogleFonts.roboto(fontSize: 13),)
                            )
                      ],
                    ),
                  ), 
                  Container(
      
                  )
              ],
            ),
            // Divider(
            //   color: couleurPrincipale,
            //   thickness: 0.2,
            // )
          ],
        ),
      ),
    );
  }
}