import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/widgets/list_friend_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_amonak/models/user.dart';

class ListePersonnePage extends StatefulWidget {
  // TextEditingController?  controller;
  const ListePersonnePage({super.key});

  @override
  State<ListePersonnePage> createState() => _ListePersonnePageState();
}

class _ListePersonnePageState extends State<ListePersonnePage>
    with AutomaticKeepAliveClientMixin {
  int counter = 0;

  List<User> users = [];

  List<User> requests = [];

  TextEditingController search = TextEditingController();

  //attente des buttons
  bool waitAcceptBtn = false;
  bool waitDeclineBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Valeur de la réquête ${widget.query}");
    // if(widget.controller!=null){
    //   widget.controller!.addListener(() {
    //     if(widget.controller!.text.length>2){
    //       print("la taille depasse 2");
    //     }
    //   });
    // }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: UserService.getAllUser(param: {})
            .then((value) => {
                  print('valeur ret²ourné\n\n'),
                  print(value.statusCode),
                  if (value.statusCode == 200)
                    {
                      users = [],
                      for (var user in jsonDecode(value.body) as List)
                        {users.add(User.fromJson(user))}
                    }
                })
            .catchError((e) {
          print(e);
        }),
        builder: (context, snashot) {
          if (snashot.hasError) {
            return Center(
              child: Text(
                "Veriviez votre Connexion",
                style: GoogleFonts.roboto(),
              ),
            );
          }
          if (snashot.hasData) {
            return StatefulBuilder(builder: (context, setState_) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: Column(
                    // alignment: WrapAlignment.spaceAround,
                    children: [
                      header(setState_),
                      // Container(
                      //   margin:const EdgeInsets.symmetric(vertical: 12),
                      //   padding:const EdgeInsets.symmetric(horizontal: 4),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(
                      //       width: 1,
                      //       color: Colors.black12
                      //     )
                      //   ),
                      //   child: FutureBuilder(future:listRequestFriend() , builder: (context,snapshot){
                      //     return Container(
                      //       width: double.maxFinite,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                      //             child: Text("Invitations",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.bold,color: couleurPrincipale),),
                      //           ),
                      //           Container(
                      //             child:Wrap(
                      //               children: [
                      //                 for(var user in requests)
                      //                 // FollowUserWidget(context, user)
                      //                 Container(
                      //                   margin: EdgeInsets.symmetric(vertical: 12),
                      //                   child: Column(
                      //                     children: [
                      //                       Container(
                      //                         width: 80,
                      //                         height: 80,
                      //                         decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.circular(56)
                      //                         ),
                      //                         child: ClipOval(
                      //                           child:user.avatar!.isNotEmpty?Image.network(user.avatar![0].url!,fit: BoxFit.cover,):Image.asset("assets/medias/profile.jpg",fit: BoxFit.cover,width: 50,) ,
                      //                         ),
                      //                       ),
                      //                       Container(
                      //                         child: Text(user.userName!,style: GoogleFonts.roboto()),
                      //                       ),
                      //                       Container(
                      //                         margin:const EdgeInsets.symmetric(vertical: 4),
                      //                         child: Wrap(
                      //                           children: [
                      //                             TextButton(onPressed: (){
                      //                               setState(() {
                      //                                   waitAcceptBtn=true;
                      //                               });

                      //                               UserService.acceptRequestFriend(id: user.id!,api: 'accept').then((value){

                      //                                 setState(() {
                      //                                   waitAcceptBtn=false;
                      //                                 });
                      //                                 print("value status code ${value.statusCode}");
                      //                                 if(value.statusCode==201){
                      //                                   successSnackBar(message: "Invitation acceptée", context: context);
                      //                                 }
                      //                                 else{
                      //                                   errorSnackBar(message: "Erreur lors de l'acceptation de l'invitation", context:context);
                      //                                 }

                      //                               }).catchError((e){
                      //                                 print("Error acceptation $e");
                      //                                 errorSnackBar(message: "Erreur lors de l'acceptation de l'invitation", context:context);

                      //                                 setState(() {
                      //                                   waitAcceptBtn=false;
                      //                               });
                      //                               });
                      //                             },
                      //                             style: TextButton.styleFrom(
                      //                               backgroundColor: couleurPrincipale.withAlpha(40)
                      //                             )
                      //                             ,child:waitAcceptBtn==false? Text("Accepter Invitaion",style: GoogleFonts.roboto(fontSize: 12),):circularProgression(color: couleurPrincipale)),
                      //                             IconButton(onPressed: (){
                      //                               UserService.acceptRequestFriend(id: user.id!, api: 'reject').then((value){
                      //                                 if(value.statusCode==200){
                      //                                   for(int i=0;i<requests.length;i++ ){
                      //                                     if(user.id==requests[i].id){
                      //                                       setState(() {
                      //                                         requests.remove(i);
                      //                                       });
                      //                                     }
                      //                                   }
                      //                                 }
                      //                                 else{
                      //                                   errorSnackBar(message: 'Une erreur est survenue', context: context);
                      //                                 }
                      //                               }).catchError((e){
                      //                                 errorSnackBar(message: 'Veuillez réessayer', context: context);
                      //                               });
                      //                             }, icon:const Icon(Icons.close,color:Colors.red))
                      //                           ],
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )
                      //               ],
                      //             )
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }),
                      // ),
                      ContainerFollowerWidget(users: users)
                    ],
                  ),
                ),
              );
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<void> listRequestFriend() async {
    await UserService.getAllUser(param: {
      "friendRequest": true.toString(),
      "user": DataController.user!.id
    }).then((value) {
      if (value.statusCode == 200) {
        requests = [];
        for (var item in jsonDecode(value.body)) {
          requests.add(User.fromJson(item));
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  header(dynamic setState_) {
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
            margin: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              "\" NOUS DEVENONS CE QUE NOUS PENSONS \"",
              style:
                  GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: 280,
            height: 42,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: 'Chercher..',
                  hintStyle: GoogleFonts.roboto(fontSize: 12),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36),
                      borderSide: const BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36),
                      borderSide: const BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ))),
              onChanged: (value) {
                if (value.length >= 3) {
                  UserService.searchUser(search.text).then((value) {
                    print("values status code search:${value.statusCode}");
                    if (value.statusCode == 200) {
                      setState_(() {
                        users = [];
                        for (var item in jsonDecode(value.body) as List) {
                          users.add(User.fromJson(item));
                        }
                      });
                    }
                  }).catchError((e) {
                    print("Error $e");
                    UserService.getAllUser(param: {}).then((value) {
                      if (value.statusCode == 200) {
                        setState_(() {
                          users = [];
                          for (var item in jsonDecode(value.body) as List) {
                            users.add(User.fromJson(item));
                          }
                        });
                      }
                    });
                  });
                } else {
                  UserService.getAllUser(param: {}).then((value) {
                    if (value.statusCode == 200) {
                      setState_(() {
                        users = [];
                        for (var item in jsonDecode(value.body) as List) {
                          users.add(User.fromJson(item));
                        }
                      });
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
