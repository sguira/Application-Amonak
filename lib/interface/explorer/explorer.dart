import 'package:application_amonak/interface/articles/list_article.dart';
import 'package:application_amonak/interface/explorer/boutique.dart';
import 'package:application_amonak/interface/explorer/personne.dart';
import 'package:application_amonak/interface/explorer/publication.dart';
import 'package:application_amonak/interface/profile/publication_widget.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {

  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(
    //   // flexibleSpace: header(),
    //   automaticallyImplyLeading: false,
    //   // leading: header(),
    //   // leadingWidth: 300,
      
    //  ),
    // appBar: AppBar(
    //   // toolbarHeight: 100,
    //   automaticallyImplyLeading: false,
    //   centerTitle: true,
    //   // title: header(),
    //   elevation: 0,
    // ),
     body: DefaultTabController(
      length: 5, 
      child: Column(
        children: [
          // header(),
          Expanded(
            child: Column(
              children: [
                Container(
                  
                  margin:const EdgeInsets.only(left: 12,right: 12,top: 6),
                  padding:const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Image.asset("assets/icons/amonak.png",width: 100,), 
                    const ButtonNotificationWidget()
                  ],),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                    // leading: Container(
                    //   child:const Column(
                    //     children: [
                    //       Text("Nous dévenons ce que nous pensons")
                    //     ],
                    //   ),
                    // ),
                    toolbarHeight: 0,
                    automaticallyImplyLeading: false,
                    // excludeHeaderSemantics: true,
                    // leading: header(),
                    // flexibleSpace: header(),
                    bottom: TabBar(tabs: [
                      itemTabBar("Personne"), 
                      itemTabBar("Article"),
                      itemTabBar("Boutique"), 
                      itemTabBar("Publication"),
                      itemTabBar("Alerte"),
                    ]),
                  ),
                    body:const TabBarView(
                      children: [
                        ListePersonnePage(), 
                        Article(),
                        BoutiquePage(), 
                        PublicationPage(type: 'default',), 
                        PublicationPage(type: 'alerte')
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
     ),
    );
  }

   header() {
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
            ),
          )
        ],
      ),
    );
  }

  Tab itemTabBar(String label) {
    return Tab(
      // height: 22,
      iconMargin:const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        // width: 100, 
        child: Text(label,style: GoogleFonts.roboto(fontSize: 12),overflow: TextOverflow.ellipsis,),
      )
    );
  }

  itemArticle(String label){
    return Container(
      child: Text(label),
    );
  }
}

