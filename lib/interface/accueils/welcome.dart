
import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/connection/activation.dart';
import 'package:application_amonak/interface/accueils/connection/change_password.dart';
import 'package:application_amonak/interface/accueils/connection/reset_password.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/adresse.dart';
import 'package:application_amonak/models/auth.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/services/register.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/item_form.dart';
// import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
// import 'package:application_amonak/services/login.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  TextEditingController nom=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController secteur=TextEditingController();
  TextEditingController adresse=TextEditingController();
  bool wailLoging=false;
  bool waitRegister=false;
  int type=0;
  //

  //resetPassword
  TextEditingController emailSend=TextEditingController();
  TextEditingController code=TextEditingController();
  bool waitRequestReset=false;
  GlobalKey<FormState> formKeyReset=GlobalKey<FormState>();

  bool showErrorR=false;
  String messageR="";

  final keyCreate=GlobalKey<FormState>();
  // late VideoPlayerController videoPlayerController;

  List<Map<String,String>> activityItem=[
    {
      'value':'Nature', 
      'label':'Nature'
    },
    {
      'value':'Media', 
      'label':'Media'
    },
    {
      'value':'Restaurant', 
      'label':'Restaurant'
    },
    {
      'value':'Sport', 
      'label':'Sport'
    },
    {
      'value':'AgroAlimentaire', 
      'label':'AgroAlientaire'
    },
    {
      'value':'Aniaux', 
      'label':'Animaux'
    },
    {
      'value':'Beauté', 
      'label':'Beauté'
    },
    {
      'value':'Entreprise individuelle', 
      'label':'Entreprise individuelle'
    },
    {
      'value':'Services Aux Entreprises', 
      'label':'Services Aux Entreprises'
    },
    {
      'value':'Automobile', 
      'label':'Automobile'
    },
    {
      'value':'Cinema', 
      'label':'Cinema'
    },
    {
      'value':'Mode', 
      'label':'Mode'
    },
    {
      'value':'Jeux et divertissements', 
      'label':'Jeux et divertissements'
    },
    {
      'value':'Santé et bien être', 
      'label':'Santé et bien être'
    },
    {
      'value':'Electroménager', 
      'label':'Electroménager'
    },
    {
      'value':'Immobilier', 
      'label':'Immobilier'
    },
    {
      'value':'Informatique et technologie', 
      'label':'INformatique et technologie'
    },
    {
      'value':'Décoration interieur', 
      'label':'Décoration interieur'
    },
    
  ];

  // ChewieController? controller;
  late VideoPlayerController videoPlayerController;

  //login variable 
  final logingForm=GlobalKey<FormState>();

  

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    
   verificationToken();
    
    videoPlayerController=VideoPlayerController.asset("assets/videos/background1.mp4")..initialize().then((value){
        videoPlayerController.setLooping(true);
        videoPlayerController.play();
        setState(() {
          
        });
     }
     
    );

    

    
    
  }

  verificationToken()async{
    await LocalStorage.getUserId().then((value)async {
      // print("Valeur du token: $token");
      String? token=value;
      LocalStorage.getToken().then((value) async{
        tokenValue=token;

        if(token!=null){
        await Login.checkToken(token).then((token) {
          
          print("Token status code ${value.statusCode}\n\n\n");
          if(value.statusCode==200){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePageTab() ));
          }
        });
      }
      else{

      }
      });
      
    });
  }

  initializeChewie()async{

    // videoPlayerController=VideoPlayerController.asset("assets/videos/background1.mp4");
    // await videoPlayerController.initialize();
    // controller=ChewieController(videoPlayerController: videoPlayerController,autoPlay: true,looping: true);
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    // controller!.dispose();
    super.dispose();
    // videoPlayerController.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        // backgroundColor:const Color.fromARGB(255, 124, 108, 108),
        
        body: Stack(

          children: [
            // videoPlayerController.value.isInitialized?
            Positioned.fill(
              child: Container(
                // height: 1000,
                // child: Image.asset("assets/medias/background.jpg",fit: BoxFit.cover,)
                // child:controller!=null? Chewie(controller: controller!):Center(
                //   child: CircularProgressIndicator(strokeWidth: 1,color: Colors.red,),
                // ),
                child:videoPlayerController.value.isInitialized? VideoPlayer(videoPlayerController):Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 56),
                  child: Image.asset("assets/icons/amonak2.png",width: 220,)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Bienvenue Sur Amonak",style: GoogleFonts.roboto(fontSize: 22,fontWeight: FontWeight.w900,color: Colors.white),), 
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 22),
                          child:Text('Amonak est un réseau social e-commerce gratuit chaque compte crée est l\'équivalent d\'un site e-commerce. Achetez en toute simplicité avec garanti de 24h pour tous vos achats',style: GoogleFonts.roboto(color: Colors.white),textAlign: TextAlign.center,)), 
                        Container(
                          margin:const EdgeInsets.only(top: 36),
                          
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(22)
                            ),
                            width: 300,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white, 
                                // padding:const EdgeInsets.symmetric(vertical: 12)
                              ),
                              onPressed: (){
                                bottomSheetInscription();
                                // Get.bottomSheet(
                                
                                //   bottomSheetContainer()
                                
                                // );
                              }, child: Text('Commencez maintenant',style: GoogleFonts.roboto(fontSize:16),)
                            ),
                          ),
                        ), 
                        Container(
                          
                          margin:const EdgeInsets.symmetric(vertical: 12),
                          child: TextButton(onPressed: (){
                            // Navigator.pushNamed(context, '/home'); 
                            bottomSheetConnectionWidget();
                          }, child: Text('Se connecter',style: GoogleFonts.roboto(color: Colors.white,fontSize:18),)),
                        ),const SizedBox(height: 120,)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      )
    );
  }

   bottomSheetInscription(){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context, builder: (context)=>SingleChildScrollView(
      
        child: Wrap(
          children: [
            bottomSheetContainer(),
          ],
        ),
      ));
  }

  bottomSheetContainer() {
     
     return StatefulBuilder(

       builder: (context,setState_) {
         return Container(
          decoration:const BoxDecoration(
            // color: Colors.white
          ),
            height: ScreenSize.height*0.9,
            padding:const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    
                    margin: EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Spacer(flex: 3,),
                        Text("S'inscrire",style: GoogleFonts.roboto(fontWeight: FontWeight.w800,fontSize:18),), 
                        Spacer(flex: 2,),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon:const Icon(Icons.close)),
                        // Spacer(),
                        // Spacer(flex: 1,)
                      ],
                    ),
                  ), 
                  const SizedBox(height: 18,),
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                    child:  Text(
                      "Apprêtez vous à entrez dans un univers où vous êtes le véritable patron.",textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(),
                    ),
                  ), 
                  Container(
                    child: Form(
                      key: keyCreate,
                      child: Column(
                        children: [
                          itemTextFieldText(label: 'Votre Nom ou celui de votre boutique', hint: 'Ex. Paul / MK Store', controller: nom,validator: simpleValidator), 
                          itemTextFieldText(label: 'Votre adresse mail', hint: 'Ex. monemail@gmail.com', controller: email,validator: simpleValidator), 
                          itemTextFieldText(label: 'Votre mot de passe', hint: '', controller: password,type: "password",validator: passwordValidator),
                          itemSelectForm(controller: secteur, label: "Votre secteur d'activité", hint: 'Mode'), 
                          itemAdresseField(label: 'Votre adresse ou celle de votre boutique ', hint:  'Choisir'),
         
                          Container(
                            margin:const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("En validant ce formulaire vous acceptez nos conditions d'utilisation et notre politique de confidentialité.",style: GoogleFonts.roboto(fontSize: 11),),
                          )
                        ],
                      ),
                    ),
                  ),
                  if(showErrorR==true)
                  Container(
                    margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                            color:type==2? Colors.red:const Color.fromARGB(255, 45, 135, 48)
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:const EdgeInsets.symmetric(horizontal: 28),
                          padding:const EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: Text(messageR,style: GoogleFonts.roboto(color: Colors.white,fontSize: 12),softWrap: true, overflow: TextOverflow.clip,),
                        ), 
                         IconButton(onPressed: (){
                          setState_(() {
                            showErrorR=false;
                          });
                         }, icon:const Icon(Icons.close,color: Colors.white,))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenSize.width*0.80,
                        constraints:const BoxConstraints(
                          // maxWidth: 300
                        ),
                        margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          gradient:const LinearGradient(
                            colors:[
                              Color.fromRGBO(97, 81, 212, 1), 
                          // Color.fromARGB(255, 9, 51, 189),
                             Color.fromRGBO(132, 62, 201, 1)
                            ]
                          )
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              if(keyCreate.currentState!.validate()){
                                onCreateUser(setState_);
                              }
                            },
                            child: Center(
                              child:waitRegister==false? Center(child: Text("S'inscrire",style:GoogleFonts.roboto(color: Colors.white))):const SizedBox(
                                width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.5,color: Colors.white,),
                              ),
                            )
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
                );
       }
     );
   }

  //  Container gradientButton(String label) {
  //    return Container(
  //                 margin:const EdgeInsets.only(top: 24),
  //                 width: ScreenSize.width*0.85,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(28),
  //                   gradient:const LinearGradient(colors: [
  //                     Color.fromRGBO(97, 81, 212, 1), 
  //                     // Color.fromARGB(255, 9, 51, 189),
  //                     Color.fromRGBO(132, 62, 201, 1)
  //                   ])
  //                 ),
  //                 child: TextButton(
  //                   onPressed: (){},
  //                   style: TextButton.styleFrom(
  //                     padding:const EdgeInsets.symmetric(vertical: 20)
  //                   ),
  //                   child: Text(label,style: GoogleFonts.roboto(color: Colors.white),) 
  //                 ),
  //               );
  //  }

  passwordValidator(String? value){
    if(value!.length<6){
      return 'Au moins 6 caractères';
    }
    return null;
  }

  itemTextFieldText({
    required label, 
    required hint, 
    required controller, 
    String? type="text", 
    required Function validator
  }){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      // height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.roboto(
            fontSize: 12
          ),),
          TextFormField(
            controller: controller,
            validator: (value)=>validator(value),
            obscureText: type=="password"?true:false, 
            decoration: InputDecoration(
              // label: Text(label,style: GoogleFonts.roboto(fontSize: 12),),
              hintText: hint, 
              hintStyle: GoogleFonts.roboto(color: Colors.black45,fontSize: 12), 
              border:const UnderlineInputBorder(
                borderSide: BorderSide(width: 4)
              ), 

              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5)
              )
            ),
          ),
        ],
      ),
    );
  }

  simpleValidator(String? value){
    print("validator invoke $value");
    if(value!.isEmpty){
      return 'Champ obligatoire';
    }
    return null;
  }

  passValidator(){
    return null;
  }

  itemAdresseField(
    {
      required label,
      required hint
    }
  ){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(label,style: GoogleFonts.roboto(fontSize: 11)),
          
          Container(
            margin:const EdgeInsets.symmetric(vertical: 4),
            height: 58,
            child:TextFormField(
              decoration: InputDecoration(
                hintText: hint, 
                border:const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5
                  )
                )
              ),
            )
          ),
        ],
      ),
    );
  }

  itemSelectForm({
    required TextEditingController controller, 
    required label, 
    required hint, 
    
  }){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.roboto(fontSize: 11),),
          Container(
            child: SelectFormField(
              controller: controller,
              validator: (value){
                if(value!.isEmpty){
                  return 'Champ obligatoire';
                }
                return null;
              }, 
              decoration: InputDecoration(
                hintText: hint, 
                hintStyle: GoogleFonts.roboto(fontSize: 12)
              ),
              dialogSearchHint: 'Chercher',
              enableSearch: true, 
              style: GoogleFonts.roboto(),
              type: SelectFormFieldType.dialog,
              items: [ 
                for(var item in activityItem)

                item
               ],
              
              onChanged: (value){
                setState(() {
                  controller.text=value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  bottomSheetConnectionWidget(){
    
    TextEditingController userName=TextEditingController(); 
    TextEditingController passWord=TextEditingController();
    


    
    bool showError=false;
    String errorMessage='Problème';
    return showModalBottomSheet(context: context,
    isScrollControlled: true,
    builder: (context){
      return Container(
        margin:const EdgeInsets.symmetric(horizontal: 25,vertical: 18),
        height: 420,
        child: StatefulBuilder(
          builder: (context,setState_) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child:ListView(
                  children: [
                    // headerBottomSheet(context, 'Authentification'),
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 22),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          // const Spacer(flex: 2,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Se Connecter",style:GoogleFonts.roboto(fontSize:20,fontWeight:FontWeight.w500)),
                              Container(
                                width: ScreenSize.width*0.70,
                                child: Text("Nous sommes content de vous revoir ! Reprenons où les choses se sont arrétées.",style: GoogleFonts.roboto(fontSize:13),))
                            ],
                          ),
                          const Spacer(),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon:const Icon(Icons.close))
                        ]
                      )
                    ),
                    Container(
                      child: Form(
                        key:logingForm,
                        child: Column(
                          children: [
                            itemForm(hint: 'Ex. sguira96@gmail.com', label: "Nom d'utilisateur",controller: userName,requiet: true), 
                            itemForm(hint: '****', label: "Mot de passe",controller: passWord,requiet: true),
                            const SizedBox(height:22 ,),
                            if(showError==true)
                            widgetErrorAlert(errorMessage, setState_, showError),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showModalBottomSheet(context: context, builder:(context)=> ResetPassword());
                                  },
                                  child: Container(
                                    margin:const EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Mot de passe oublié ?',style: GoogleFonts.roboto(fontSize: 15,decoration: TextDecoration.underline),),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    gradient:const LinearGradient(
                                      colors: [
                                       Color.fromRGBO(97, 81, 212, 1), 
                                                        // Color.fromARGB(255, 9, 51, 189),
                                      Color.fromRGBO(132, 62, 201, 1)
                                      ]
                                      )
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      
                                    ),
                                    onPressed: (){
                                      if(logingForm.currentState!.validate()){
                                        setState_(() {
                                          wailLoging=!wailLoging;
                                          Auth auth=Auth(userName: userName.text,passWord: passWord.text);
                                          Login.authenticated(auth).then((value){
                                            setState_((){
                                              wailLoging=false;
                                            });
                                            print("\n\n\n valeur retour $value \n\n");
                                            if(value.statusCode!=200){
                                             if(jsonDecode(value.body)['message']=='validation.accountNotActivate'){
                                              Navigator.pop(context);
                                              showModalBottomSheet(context: context, builder: (context)=> ConfirmCodeActivation(email:userName.text,) );
                                             }
                                             else{
                                               errorMessage="Verifiez vos coordonnées";
                                                setState_((){
                                                  showError=true;
                                                  Future.delayed(const Duration(milliseconds: 3000)).then((value){
                                                    setState_((){
                                                      showError=false;
                                                    });
                                                  });
                                                });
                                             }
                                            }
                                            else{
                                              LocalStorage.saveToken(jsonDecode(value.body)['accessToken'] as String).then((value){
                                                print("\n\n\n valeur retour $value \n\n");
                                                LocalStorage.saveUserId(DataController.user!.id!).then((value){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageTab()));
                                                });
                                                
                                              });
                                              
                                            }
                                          }).catchError((e){
                                            setState_((){
                                              wailLoging=false;
                                              errorMessage='Un problème est survenue';
                                              showError=true;
                                            });
                                          });
                                      });
                                      }
                                    },
                                    child:Center(child: wailLoging==false? Text('Connexion',style: GoogleFonts.roboto(color:Colors.white),):SizedBox(width: 28,height: 28, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,))  )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                    bottomSheetInscription();
                                  },
                                  child: Container(
                                    margin:const EdgeInsets.symmetric(vertical: 12),
                                    child: Text("Je n'ai pas encore de compte",style: GoogleFonts.roboto(fontSize: 15,decoration: TextDecoration.underline),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              
            );
          }
        ),
      );
    });
  }

  Container widgetErrorAlert(String errorMessage, StateSetter setState_, bool showError) {
    return Container(
                          decoration: BoxDecoration(
                            color: Colors.red, 
                            borderRadius: BorderRadius.circular(36)
                          ),
                          // margin: EdgeInsets.only(left: 12),
                          margin:const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin:const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(errorMessage,style: GoogleFonts.roboto(color:Colors.white),)), 
                              IconButton(onPressed: (){
                                setState_(() {
                                  showError=false;
                                });
                              }, icon:const Icon(Icons.close,color:Colors.white))
                            ],
                          ),
                        );
  }

  onCreateUser(Function function){
    showErrorR=false;
    function((){
      waitRegister=true;
    });
    User user=User();
    user.email=email.text;
    user.password=password.text;
    user.userName=nom.text;
    Address adress=Address(countryCode: '225',state: 'CI',city:adresse.text);
    // user.address!.add(adress);
    // user.
    print(" Email: ${user.email}\n\n ${user.userName}");
    print("passWord ${user.password} \n\n");
    Register.createUser(user).then((value){
      print("\n\n Value retourné: $value");
      function((){
        waitRegister=false;
      });
      print("\n\n Value retourné: $value");
      if(value=='ERROR'){
        function((){
         showErrorR=true;
         messageR="Un problème est survenue";
         type=2;
        });
      }
      else{
        showErrorR=true;
        messageR="Votre compte est crée veuillez confirmer par mail";
        type=1;
      }
    }).catchError((e){
      print(e);
      function((){
        waitRegister=false;
      });
    });
  }

  

 gotoChangePassword()async{
    await Future.delayed(Duration(seconds: 5));
    Navigator.pop(context);
    return showModalBottomSheet(context: context, builder: (context)=>ChangePassword() );
  }

  TextButton buttonAction( Function onPressed, String btnTexte) {
    return TextButton(onPressed: (){
      if(formKeyReset.currentState!.validate()){
        setState(() {
          waitRequestReset=true;
        });
        onPressed();
        setState(() {
          waitRequestReset=false;
        });
      }
    }, child:waitRequestReset==false? Text(btnTexte.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),):SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),));
  }
}