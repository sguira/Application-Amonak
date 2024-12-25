import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter/material.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // List<String> videos=[
  //   "assets/videos/background1.mp4", 
  //   "assets/videos/background1.mp4", 
  //   "assets/videos/background1.mp4", 
  //   "assets/videos/background1.mp4", 
  //   "assets/videos/background1.mp4"
  // ];

  List<Color> colors=[
    Colors.red, 
    Colors.blue,  
    Colors.yellow, 
    Colors.green
  ];

  
  late VideoPlayerController videoPlayerController;

  int videoIndex=0;

  int currentPage=0;
  List<Publication> publication=[];

  final PageController pageController=PageController(
    // viewportFraction: 0.1, 

  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: PublicationService.getPublications().then((value) {
          try{
            print("value ss ${value.body}\n\n\n");
            if(value.statusCode.toString()=='200'){
              publication=[];
              for(var item in jsonDecode(value.body) as List){
                Publication pub=Publication.fromJson(item);
                print("content- ${pub.content} ${pub.files[0].type}");
                print("typesss ${pub.files[0].type} ");
                if(pub.files[0].type=='video'){
                  publication.add(pub);
                }
                // publication.add(pub);
              }
              print("tailles -des vidéos!! ${publication.length} \n type ${publication[0].files[0].type}");
            }
          }
          catch(e){
            print(e);
          }
        }).catchError((e){
          print("ERROR $e\n\n\n");
        }),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: couleurPrincipale,
                  ),
                ), 
                Text("chargement des vidéos")
              ],
            );
          }
          if(snapshot.hasError){
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("Error")),
              ],
            );
          }
          return PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical, 
            itemCount: publication.length,
            padEnds: true,
            onPageChanged: (index){
              // setState(() {
              //   currentPage=index;
              // });
              //arret de la vidéo précedente
          
            },
            
            itemBuilder: (context,index){
              return publication.isNotEmpty? VideoPlayerWidget(videoItem: publication[index],index: index,):Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Center(child: Text("Aucune publication"),)],);
                
            },
           );
        }
      )
    );
  }

  videoContainer(){
    return Container(
      child: VideoPlayer(videoPlayerController),
    );
  }
}