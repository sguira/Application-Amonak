import 'dart:convert';

import 'dart:ui';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/notifications.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/interface/vendre/vendre.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/btnLike.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/buttonComment.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
class VideoPlayerWidget extends StatefulWidget {
  final Publication videoItem;
  final int index;
  const VideoPlayerWidget({super.key,required this.videoItem,required this.index});
  
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {


  late VideoPlayerController controller;
  int  nbLike=0;
  bool isLike=false;
  late String idLike;
  bool viewBtn=false;
  List hearts=[];
  double sizeLike=12;
  bool showFavourite=false;
  bool isExpanded=false;
  nombreComment()async{
    await CommentaireService.getCommentByPublication(pubId: widget.videoItem.id!).then((value){
      if(value.statusCode.toString()=='200'){
        setState(() {
          nbComment=(jsonDecode(value.body) as List).length;
        });
      }
    });
  }

  Future getArticle()async{
    if(widget.videoItem.typePub=='sale'){
      await ProductService.getSingleArticle(id: widget.videoItem.productId).then((value) {
        if(value.statusCode==200){
          article=ArticleModel.fromJson(jsonDecode(value.body));
        }
      }).catchError((e){
        print(e);
      });
    }
  }

  ArticleModel? article;

  int nbComment=0;


List likes=[];  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArticle();
    setState(() {
      
      getNombreLike();
      nombreComment();
    });
    print("Video ID ${widget.videoItem.id}\n\n");
    if(DataController.checVideoExist(widget.videoItem.id!)==null){
      controller=VideoPlayerController.networkUrl(Uri.parse(super.widget.videoItem.files[0].url!))
      ..initialize().then((value) {
        controller.setLooping(true);
        controller.play();
        setState(() {
          
        });
        Map video={
          'id':widget.videoItem.id, 
          'controller':controller
        };

        // DataController.videoControllerHistory.add(video);
      });

    }
    else{
      controller=DataController.checVideoExist(widget.videoItem.id!)['controller'];
    }
    
  }

 
    

  

  getNombreLike()async{
    await PublicationService.getNumberLike(widget.videoItem.id!, 'like').then((value){
      print("nombre like");
      if(value!.statusCode.toString()=='200'){
        setState(() {
          nbLike=(jsonDecode(value.body)as List).length;
          print("nombre de like $nbLike\n\n $isLike");
        });
        
        if(nbLike>0){
          for(var i in jsonDecode(value.body) as List){
          if(i['user']!=null){
            if(i['user']['_id']==DataController.user!.id){
              setState(() {
                isLike=true;
                idLike=i['_id'];
              });    
            }
          }
        }
        }
        
      }
    }).catchError((e){
      setState(() {
        isLike=false;
        nbLike=0;
      });
      print("ERORRRT $e \n\n");
    });
  }

  deleteLike()async{
    if(isLike){
      await PublicationService.deleteLike(idLike).then((value){
        print("SUppression like ${value.statusCode} .. \n\n");
        setState(() {
          isLike=false;
          nbLike-=1;
        });
        if(value.statusCode.toString()!='200'){
          setState(() {
            isLike=true;
            nbLike+=1;
          });
        }
      }).catchError((e){
        setState(() {
            isLike=true;
            nbLike+=1;
          });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    nbLike=0;
    isLike=false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        controller.value.isInitialized? 
          Center(
            child: GestureDetector(
              onDoubleTap: (){
                // showHeart();
                setState(() {
                        showFavourite=true;
                        
                      });
                      Future.delayed(const Duration(milliseconds: 1200),(){
                        setState(() {
                          showFavourite=false;
                        });    
                      });
                if(isLike==false){
                  likePublication();
                  
                }
                else{
                  deleteLike();
                }
              },
              onTapUp: (details){
                print("on tap Up");
                
              },
              
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        viewBtn=!viewBtn;
                      });
                      Future.delayed(const Duration(milliseconds: 4000),(){
                        setState(() {
                          viewBtn=false;
                        });
                      });
                    },
                    
                    child: AspectRatio(
                      
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(
                        controller
                      ),
                    ),
                  ),
                  
                  if(viewBtn)
                  GestureDetector(
                    
                    child: Container(
                      width: 150, 
                      height: 150,
                      color: Colors.transparent,
                      child: Container(
                        padding:const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(58),
                          color: Colors.black.withAlpha(80)
                        ),
                        child: IconButton(onPressed: (){
                          setState(() {
                            if(controller.value.isPlaying){
                            controller.pause();
                            }
                            else{
                              controller.play();
                            }
                          });
                        }, icon: Icon(controller.value.isPlaying? Icons.play_arrow:Icons.pause  ,color: couleurPrincipale,size: 56,))),
                    ),
                  ),
                  // Icon(
                  //   Icons.favourit
                  // )
                ],
              ),
            ),
          ):const WaitWidget(), 
        header(),
        if(showFavourite==true)
        Animate(
          effects:const [
            ScaleEffect(duration: Duration(milliseconds: 500)), 
            ShakeEffect(duration: Duration(milliseconds: 500))
          ],
          child: const Center(
            child: Icon(Icons.favorite,color: Colors.red,size: 90,)
            
          )
        ),
        containerButton(), 
        containerDescription()
      ],
    );
  }

  containerDescription(){
      return widget.videoItem.content!.isNotEmpty?
     Positioned(
      bottom: 20, 
      left: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(60),
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(article!=null)
            Container(
              margin:const EdgeInsets.only(right: 12,left: 12,top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: article!.currency!).format(article!.price),style: GoogleFonts.roboto(fontSize:18,fontWeight:FontWeight.w800,color:Colors.white),), 
                  Text(article!.name!,style: GoogleFonts.roboto(color:Colors.white),), 
                  Text("Stock: ${article!.qte}",style: GoogleFonts.roboto(color:Colors.white),)
                ],
              ),
            ),
            TextExpanded(),
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
              // child: Text(calculateTimeDifferenceBetween(startDate: widget.videoItem.dateCreation!, endDate: DateTime.now()),style: GoogleFonts.roboto(color:Colors.white,fontSize:10),),
            )
          ],
        ),
      )
    ):const Center();
  }

  calculateDiffenceDate({
    required DateTime from, 
    required DateTime to
  }){
    // int seconde=to.difference(other)
  }
  

  Container TextExpanded() {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      
      decoration: BoxDecoration(
        // color: Colors.black.withAlpha(80), 
        borderRadius: BorderRadius.circular(4)
      ),
      width: ScreenSize.width*0.75,
      constraints:BoxConstraints(maxHeight:isExpanded==false? 130:ScreenSize.height*0.6),
      child: SingleChildScrollView(
        child:widget.videoItem.content!.length>100? Text.rich(
          TextSpan(
            
            children: [
              TextSpan(
                text: isExpanded==false? super.widget.videoItem.content!.substring(0,100):widget.videoItem.content!, 
                style: GoogleFonts.roboto(color:Colors.white)
              ), 
              TextSpan(
                text:isExpanded==false? " voir plus...":"voir moins",
                style: GoogleFonts.roboto(color:Colors.white,fontWeight:FontWeight.bold ),
                recognizer: TapGestureRecognizer(
                  
                )..onTap=(){
                  setState(() {
                    isExpanded=!isExpanded;
                  });
                }
              )
            ]
          )
        ):Text(widget.videoItem.content!),
      )
    );
  }

  Positioned containerButton() {
    return Positioned(
          bottom: 20, 
          right: 20,
          child: Container(
            // width: 100,
            child: Column(
              children: [
                // Text("T"),
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 22),
                  padding:const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60), 
                    borderRadius: BorderRadius.circular(22)
                  ),
                  child: Column(
                    children: [
                      ButtonLike(pub: widget.videoItem,color: Colors.white,),
                      
                      // itemButton(double.parse("80000"),Icons.repeat,false,onComment),
                      CommentaireButton(pubId: widget.videoItem.id!,color: Colors.white,pub: widget.videoItem,),
                      Container(
                        child: Column(
                          children: [
                            IconButton(onPressed: (){
                              // onComment();
                            }, icon:const Icon(Icons.repeat,color: Colors.white)),
                            Text(NumberFormat.compact(locale: 'fr').format(0),style: GoogleFonts.roboto(fontSize: sizeLike,color: Colors.white),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(widget.videoItem.typePub=='sale')
                itemButtonStyleBackground()
              ],
            ),
          )
        );
  }

  header(){
    return Positioned(
      // top: 0,
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withAlpha(68)
        ),
      margin:const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: widget.videoItem.user!)));
          },
          child: Container(
            width: 45, 
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2, 
                color: Colors.white, 
                
              ), 
              borderRadius: BorderRadius.circular(86)
            ),
            child: ClipOval(
              
              child: DataController.user!.avatar!.isEmpty? Image.asset('assets/medias/profile.jpg',fit: BoxFit.cover,):Image.network(DataController.user!.avatar!.first.url!,fit: BoxFit.cover,)),
          ),
        ), 
        Container(
          child: Text(widget.videoItem.userName!.toUpperCase(),style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize:14,color: Colors.white),),
        ), 
        const ButtonNotificationWidget(
          color: Colors.white,
        )
      ],),
    ));
  }

  Container itemButtonStyleBackground() {
    return Container(
                  child: Column(
                    children: [
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(36), 
                          border: Border.all(
                            color: couleurPrincipale, 
                            width: 2
                          )
                        ),
                        child: IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>VendrePage(articleId: widget.videoItem.productId,article: null) ));
                        }, icon:const Icon(Icons.shopping_cart)),
                      ), 
                      Text(NumberFormat.compact().format(10000),style: GoogleFonts.roboto(fontSize:11,color:Colors.white),)
                    ],
                  ),
                );
  }

  itemButton(int value,IconData icon,Function function) => Container(
    margin:const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        IconButton(onPressed: function(), icon: Icon(icon,color:isLike==false? Colors.white:Colors.red,)),
        Text(NumberFormat.compact(locale: 'fr').format(value),style: GoogleFonts.roboto(fontSize: 8,color: Colors.white),)
      ],
    ),
  );

  void onLiker(){
   setState(() {
    if(isLike){
      deleteLike();
    }
    else{
      likePublication();
    }
   });
  }

  void onShare(){

  }

  onComment(){
    print("Commentaire \n\n");
    return showCustomModalSheetWidget(context: context,child: CommentaireWidget(pubId: widget.videoItem.id,pub:widget.videoItem) );
    
  }

  likePublication()async{
    Map data={
      "publication":widget.videoItem.id, 
      "user":DataController.user!.id,
      "type":'like'
    };
    if(isLike==false){
      setState(() {
        isLike=true;
        nbLike+=1;
      });
      PublicationService.addLike(data).then((value) {
        print("Status like ${value.statusCode}\n\n");
        if(value.statusCode.toString()!='200'){

          setState(() {
            isLike=false;
            nbLike-=1;
          });
        }
      }).catchError((e){
        setState(() {
          isLike=false;
          nbLike-=1;
        });
      });
    }


  }
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({super.key});

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> with TickerProviderStateMixin {
  
  late AnimationController _controllerAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerAnimation=AnimationController(vsync: this,duration: const Duration(milliseconds: 800));

    scaleAnimation=Tween<double>(
      begin: 0.5, 
      end: 1.5
    ).animate(CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeOut));

    _controllerAnimation.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerAnimation.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controllerAnimation, 
      child: ScaleTransition(
        scale: scaleAnimation, 
        child:const Icon(
          Icons.favorite,
          color: Colors.red, 
          size: 50,
        ),
      ),
      
    );
  }
}