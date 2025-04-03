import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/contact/contact.dart';
import 'package:application_amonak/interface/contact/contact2.dart';
import 'package:application_amonak/interface/explorer/explorer.dart';
import 'package:application_amonak/interface/nouveau/new.dart';
import 'package:application_amonak/interface/profile/profile.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
class HomePageTab extends StatefulWidget {
  const HomePageTab({super.key});

  @override
  State<HomePageTab> createState() => _HomeState();
}

class _HomeState extends State<HomePageTab> {

  int currentIndex=0;

  double iconSize=22;

  late Notificationsocket notificationsocket;

  dynamic widgets=[ 
    const HomePage(),
    const ExplorerPage(),
    const NewPage(),
    Contact(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    
    notificationsocket=Notificationsocket();

    

    notificationsocket.socket!.on("refreshNotificationBoxHandler", (handler){

      print("Notification reussi dépuis home !!!");

      if(handler['to']==DataController.user!.id){
        print("Notification reussi dépuis home !!!");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widgets[currentIndex],
        bottomNavigationBar: 
          personnalityBottomBar()
        ),
      
    );
  }

  Container personnalityBottomBar() {
    return Container(
          margin:const EdgeInsets.symmetric(horizontal: 12),
          // decoration: BoxDecoration(
          //   color: Colors.red
          // ),
          child: Container(
            margin:const EdgeInsets.only(top: 6),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                itemNavigation('Accueil',Icons.home,Icons.home,0), 
                itemNavigation('Explorer', Icons.search,Icons.search,1), 
                itemHome(2), 
                itemNavigation('Discussions', Icons.comment,Icons.comment_outlined,3), 
                itemProfile(4)
              ],
            ),
          ),
        );
  }

  GestureDetector itemProfile(int index) {
    return GestureDetector(
      onTap: () {
        print(currentIndex);
        setState(() {
          currentIndex=index;
        });
      },
      child: Container(
                  width: 46, 
                  height: 46,
                  margin:const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color:currentIndex==index? couleurPrincipale:Colors.black
                    ), 
                    borderRadius: BorderRadius.circular(36)
                  ),
                  child: ClipOval(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(86),
                          // border: Border.all(width: 4)
                      ),
                      child:DataController.user!.avatar!.isEmpty? Image.asset("assets/medias/profile.jpg",fit:BoxFit.cover):Image.network(DataController.user!.avatar!.first.url!,fit:BoxFit.fitHeight)),
                  ),
                ),
    );
  }

  GestureDetector itemHome(int index) {
    return GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex=index;
                  });
                },
                child: Container(
                  // margin:const EdgeInsets.symmetric(horizontal:12,vertical: 2),
                  padding:const EdgeInsets.symmetric(horizontal: 8),
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: currentIndex==index? couleurPrincipale:Colors.white,
                    borderRadius: BorderRadius.circular(36), 
                    border: Border.all(
                      width: 1, 
                      color:currentIndex==index? couleurPrincipale:Colors.black.withAlpha(60)
                    )
                  ),
                  child: Center(child: Icon(Icons.add,size: iconSize,color:currentIndex==index? Colors.white:Colors.black)),
                ),
              );
  }

  itemNavigation(String label,IconData icon,IconData icon2,int index){
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex=index;
        });
      },
      child: Container(
        margin:const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Icon(currentIndex==index?icon:icon2,weight: 36,size: iconSize,color:currentIndex==index? couleurPrincipale:Colors.black, ),
            Text(label,style: GoogleFonts.roboto(fontSize: 9,color:currentIndex==index? couleurPrincipale:Colors.black))
          ],
        ),
      ),
    );
  }
}