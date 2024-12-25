import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart';
import 'package:application_amonak/interface/explorer/image_container.dart';
import 'package:application_amonak/interface/explorer/videoPlayerWidget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
// import 'package:popover/popover.dart';
class PublicationPage extends StatefulWidget {
  final String type;
  final String? userId;
  const PublicationPage({super.key,required this.type,this.userId});

  

  @override
  State<PublicationPage> createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {

  List<Publication> publication=[];
  late VideoPlayerController videoController;
  late int nbLike=0;
  late bool isLiked=false;
  String type=''; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  getNombreLike()async{
    // await PublicationService.getNumberLike(widget., type)
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PublicationService.getPublications(type: super.widget.type, userId:widget.userId ).then((value) {
        print("Status code : ${value.statusCode}");
        print(value.body);
        publication=[];
        if(value.statusCode.toString()=='200'){
          for(var item in jsonDecode(value.body) as List){
            print("value ${item['content']}\n\n");
            
            print("value ${item['user']['userName']}\n\n");
            Publication pub=Publication.fromJson(item);
            print("ttt ${pub.files[0].type} ");
            publication.add(pub); 
          }
        }
      }).catchError((e){
        print("error: $e\n\n");
      }),
      builder: (context,snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return  Container(
            alignment: Alignment.center,
            margin:const EdgeInsets.symmetric(vertical: 22),
            child: const SizedBox(
              width: 36, 
              height: 36, 
              child: CircularProgressIndicator(
                strokeWidth: 1, 
                color: couleurPrincipale,
              ),
            ),
          );
        }
        if (snapshot.hasError){
          return Container(
            margin:const  EdgeInsets.symmetric(vertical: 22),
            child:const Center(child: Text('Error'))
          );
        }
        return publication.isNotEmpty?
          Container(
          child: ListView.builder(
            // alignment: WrapAlignment.center,
            itemCount: publication.length,
            itemBuilder: (context, index) {
              return ItemPublication(pub: publication[index]);
            },
            addAutomaticKeepAlives: false,
            
          ),
        ):const Center(child: Text("Aucun element trouvé"),);
      }
    );
  }

  bodyContainer(Publication item){
    return Column(
      children: [
        textContainer(item.content!),
        if(item.files.isNotEmpty&&item.files[0].url!='')
        item.files[0].type=='image'?
        imageContaint(item.files[0].url)
        :VideoPlayerWidget2(url: item.files[0].url!)
      ],
    );
  }
  textContainer(String texte){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 12),
      width: ScreenSize.width*0.8,
      // height: 80,
      constraints:const BoxConstraints(maxHeight: 80),
      child: Text(texte,textAlign: TextAlign.start,style: GoogleFonts.roboto(fontSize: 12), overflow: TextOverflow.fade,),
    );
  }

  imageContaint(String? image){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 2,vertical: 12),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(11), 

      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child:image!=''?Image.network(image!): Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,)),
    );
  }

  

    
   

  footerContainer(Publication publication){
    return Container(
      // margin: ,
      margin:const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              itemDescription("100", "Likes"), 
              GestureDetector(
                onTap: (){
                  showBottomSheet(context: context, builder: (context)=>CommentaireWidget(publication: publication));
                },
                child: itemDescription("5000", "Commentaires"),
              ),
              itemDescription("10000", "Partages"),
            ],
          ), 
          Row(
            children: [
              buttonIcon(Icons.favorite_border), 
              buttonIcon(Icons.comment),
              buttonIcon(Icons.repeat)
            ],
          )
        ],
      ),
    );
  }

  

  Container buttonIcon(IconData icon) => Container(
    margin:const EdgeInsets.symmetric(horizontal: 3),
    child: Icon(icon,size: 28,));

  itemDescription(String value,String label){
    return Container(
      // width: 60,
      margin:const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Text(NumberFormat.compact(locale: 'fr', ).format(int.parse(value)),style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 12),),
          const SizedBox(width: 2,), 
          Container(
            width: 32,
            child: Text(label,style: GoogleFonts.roboto(fontSize: 9),overflow: TextOverflow.ellipsis,))
        ],
      ),
    );
  }

  headerBoutique(Publication item,int style){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      padding:const EdgeInsets.symmetric(vertical: 12,horizontal: 2),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42, 
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(86), 
              color: Colors.black12
            ),
            child: ClipOval
            (child: Image.asset('assets/medias/user.jpg',width: 45,fit: BoxFit.cover,)),), 
            Column(
              children: [
                Text(item.userName!,style: GoogleFonts.roboto(fontWeight: FontWeight.w600),),
                // style!=1?
                // Text(item['type'],style: GoogleFonts.roboto(fontSize: 10),):Container()
              ],
            ), 
            Container(
              child: PopupMenuButton(itemBuilder: (context)=>[
                PopupMenuItem(child: TextButton(onPressed: (){
                  alerteSuppression(item.id!);
                }, child:const Row(
                  children: [
                    Icon(Icons.delete),
                    Text('Supprimer'),
                  ],
                )))
              ]),
            )
        ],
      ),
    );
  }

  alerteSuppression(String id){
    Navigator.pop(context);
    bool wait=false;
    return showDialog(context: context, builder: (context)=>StatefulBuilder(
      builder: (context,setState_) {
        return AlertDialog(
          title: Text("Confirmer la suppression",style:GoogleFonts.roboto(fontWeight:FontWeight.bold)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          content: Container(
            child: Text("Cette action aura pour consequence la suppression de la publication",style: GoogleFonts.roboto(fontSize:14),),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Annuler')),
            TextButton(onPressed: (){
              setState_(() {
                wait=true;
              });
              PublicationService.suppression(id).then((value){
                setState_((){
                  wait=false;
                });
                print("status Code ${value}\n\n\n");
                if(value.toString()!='200'){
                  
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La publication a été supprimé!')));
                  setState(() {
                    
                  });
                }
                setState(() {
                  deleteLocal(id);
                });
                Navigator.pop(context);
              }).catchError((e){
                print("ERROR $e");
              });
            }, child: wait==false? const Text('Confirmer'):Container(
              margin:const EdgeInsets.symmetric(horizontal: 22),
              child:const CircularProgressIndicator(strokeWidth: 1,)))
          ],
        );
      }
    ));
  }

  deleteLocal(String id){
    publication=[];
    for(Publication i in publication){
      if(i.id!=id){
        publication.add(i);
      }
    }
  }

  deletePublication(String id){

  }
}