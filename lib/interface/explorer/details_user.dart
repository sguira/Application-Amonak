import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/interface/explorer/publication.dart';
import 'package:application_amonak/interface/profile/edit_profile.dart';
import 'package:application_amonak/interface/profile/gestion_profile.dart';
import 'package:application_amonak/interface/profile/list_abonne.dart';
import 'package:application_amonak/interface/profile/profile.dart';
import 'package:application_amonak/interface/profile/publication_widget.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class DetailsUser extends StatefulWidget {
  final User user;
  const DetailsUser({super.key,required this.user});

  @override
  State<DetailsUser> createState() => _DetailsUserState();
}

class _DetailsUserState extends State<DetailsUser> {

  bool waitSendFriend=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:const Icon(Icons.arrow_back,size: 18,)),
        
      ),
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 250,
                elevation: 0,
                scrolledUnderElevation: 0,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: headerProfile(),
                )
              )
            ];
          },
          
          body: userPageContainer(),
        ),
      ),
    );
  }

  Widget userPageContainer() {
    return Container(
      margin:const  EdgeInsets.symmetric(vertical: 12),
      child: DefaultTabController(
            length: 4, child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false, 
                toolbarHeight: 0,
                bottom: TabBar(tabs: [
                  itemTab('articles',2000),
                  itemTab('publications',2000), 
                  itemTab('alertes',572454), 
                  itemTab('abonné',2000)
                ]),
                
              ),
              body: TabBarView(children: [
                FutureListArticle(userId: widget.user.id!),
                PublicationPage(type: 'default',userId: widget.user.id),
                PublicationPage(type: 'alerte',userId: widget.user.id),
                const ListAbonnee()
              ]),
            ), 
            
          ),
    );
  }

  Tab itemTab(String label,int value) {
    return Tab(height: 40,
                    child: Column(
                      children: [
                        Text(NumberFormat.compact(locale: 'fr').format(value),style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.bold),), 
                        Text(label.toUpperCase(),style: GoogleFonts.roboto(fontSize: 7),overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  );
  }

  isFriend(String id){
    for(var item in DataController.friends){
      if(item.id == id){
        return true;
      }
    }
    return false;
  }

  Column headerProfile() {
    return Column(
      children: [
        
        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 1,),
                  Container(
                    width: 100, 
                    height: 100,
                    margin:const EdgeInsets.symmetric(vertical: 2),
                    child: ClipOval(
                  
                      child: Image.asset("assets/medias/profile.jpg",fit: BoxFit.cover,),
                    ),
                  ),
                ],
              ),
        
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: Text(widget.user.userName!.toUpperCase(),style:GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500,letterSpacing:3)),
        ), 
        Container(
          margin:const EdgeInsets.symmetric(vertical: 4,horizontal: 22),
          child: Text(widget.user.description??'Aucune Description',style: GoogleFonts.roboto(fontSize: 11),textAlign: TextAlign.center,),
        ),
        if(widget.user.id!!=DataController.user!.id!)
        Container(
          margin:const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isFriend(widget.user.id!)==false?
              Container(
                padding:const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: linearGradient, 
                  borderRadius: BorderRadius.circular(36)
                ),
                child:waitSendFriend==false? Row(
                  children: [
                    const Icon(FontAwesomeIcons.add,size:16,color: Colors.white,),
                    const SizedBox(width: 2,),
                    StatefulBuilder(
                      builder: (context,setState_) {
                        // setState_((){
                        //   waitSendFriend
                        // });
                        return  TextButton(onPressed: (){
                          sendFriendRequest(setState_);
                        }, child: Text("S'abonner",style:GoogleFonts.roboto(color: Colors.white,fontSize: 12)));
                      }
                    ),
                  ],
                ): Center(child: Container(
                  margin:const EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  child:const SizedBox(width: 22,height: 22,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,),)),),
              ): 
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 22),
                decoration: const BoxDecoration(
                  
                ),
                          child: Wrap(
                            children: [
                              const Icon(Icons.check,size: 18,), 
                              Text("Abonné",style: GoogleFonts.roboto(fontSize: 12),)
                            ],
                          ),
              ),
              const SizedBox(width: 32,),
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: linearGradient,
                  borderRadius: BorderRadius.circular(36)
                ),
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage(user: widget.user,) ));
                }, child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.envelope,size:16,color: Colors.white,),
                    const SizedBox(width: 6,),
                    Text("Contacter",style:GoogleFonts.roboto(color: Colors.white,fontSize: 12)),
                  ],
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
  header(){
    return Container(
      height: 70, 
      decoration:const BoxDecoration(color: Colors.red),
    );
  }

  sendFriendRequest(dynamic setState_){
    setState_(() {
      waitSendFriend=true;
    });
    UserService.sendFriend(widget.user.id!).then((value){
      setState_(() {
        waitSendFriend=false;
      });
      if(value=="OK"){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitation envoyée.')));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("vérifiez votre connexion.",style: GoogleFonts.roboto(color:Colors.white),),backgroundColor: Colors.red.withAlpha(60), ));
      }
    });
  }
}