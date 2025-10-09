import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/auths/LoginContainer.dart';
import 'package:application_amonak/interface/connection/activation.dart';
import 'package:application_amonak/interface/connection/change_password.dart';
import 'package:application_amonak/interface/connection/create_user.dart';
import 'package:application_amonak/interface/connection/reset_password.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/adresse.dart';
import 'package:application_amonak/models/auth.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/register.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/circular_progressor.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/item_form.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_form_field/select_form_field.dart';

// import 'package:application_amonak/services/login.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool wailLoging = false;
  bool waitRegister = false;
  int type = 0;
  //

  //resetPassword
  TextEditingController emailSend = TextEditingController();
  TextEditingController code = TextEditingController();
  bool waitRequestReset = false;
  GlobalKey<FormState> formKeyReset = GlobalKey<FormState>();

  bool showErrorR = false;
  String messageR = "";

  final keyCreate = GlobalKey<FormState>();
  // late VideoPlayerController videoPlayerController;

  // ChewieController? controller;
  late VideoPlayerController videoPlayerController;

  //login variable
  final logingForm = GlobalKey<FormState>();
  bool waitVerification = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    videoPlayerController =
        VideoPlayerController.asset("assets/videos/background1.mp4")
          ..initialize().then((value) {
            videoPlayerController.setLooping(true);
            videoPlayerController.play();
            setState(() {});
          });
  }

  initializeChewie() async {
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
    return SafeArea(
        child: Scaffold(
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
            child: videoPlayerController.value.isInitialized
                ? VideoPlayer(videoPlayerController)
                : Image.asset(
                    "assets/medias/user.jpg",
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 56),
                child: Image.asset(
                  "assets/icons/amonak2.png",
                  width: 220,
                )),
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
                    Text(
                      "Bienvenue Sur Amonak",
                      style: GoogleFonts.roboto(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          'Amonak est un réseau social e-commerce gratuit chaque compte crée est l\'équivalent d\'un site e-commerce. Achetez en toute simplicité avec garanti de 24h pour tous vos achats',
                          style: GoogleFonts.roboto(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 36),
                      child: Container(
                        // padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22)),
                        width: 300,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              // padding:const EdgeInsets.symmetric(vertical: 12)
                            ),
                            onPressed: () {
                              bottomSheetInscription();
                              // Get.bottomSheet(

                              //   bottomSheetContainer()

                              // );
                            },
                            child: Text(
                              'Commencez maintenant',
                              style: GoogleFonts.roboto(fontSize: 16),
                            )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: TextButton(
                          onPressed: () async {
                            showCustomModalSheetWidget(
                                context: context,
                                child: const LoginContainer());
                          },
                          child: waitVerification == false
                              ? Text(
                                  'Se connecter',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 18),
                                )
                              : circularProgression()),
                    ),
                    const SizedBox(
                      height: 120,
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    )));
  }

  bottomSheetInscription() {
    return showCustomModalSheetWidget(
        context: context, child: const CreateAccount());
  }

  itemTextFieldText(
      {required label,
      required hint,
      required controller,
      String? type = "text",
      required Function validator}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      // height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(fontSize: 13),
          ),
          TextFormField(
            controller: controller,
            validator: (value) => validator(value),
            obscureText: type == "password" ? true : false,
            decoration: InputDecoration(
                // label: Text(label,style: GoogleFonts.roboto(fontSize: 12),),
                hintText: hint,
                hintStyle:
                    GoogleFonts.roboto(color: Colors.black45, fontSize: 12),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 4)),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.5))),
          ),
        ],
      ),
    );
  }

//chargement des données après login

  Container widgetErrorAlert(
      String errorMessage, StateSetter setState_, bool showError) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(36)),
      // margin: EdgeInsets.only(left: 12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                errorMessage,
                style: GoogleFonts.roboto(color: Colors.white),
              )),
          IconButton(
              onPressed: () {
                setState_(() {
                  showError = false;
                });
              },
              icon: const Icon(Icons.close, color: Colors.white))
        ],
      ),
    );
  }

  gotoChangePassword() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);
    return showModalBottomSheet(
        context: context, builder: (context) => const ChangePassword());
  }

  TextButton buttonAction(Function onPressed, String btnTexte) {
    return TextButton(
        onPressed: () {
          if (formKeyReset.currentState!.validate()) {
            setState(() {
              waitRequestReset = true;
            });
            onPressed();
            setState(() {
              waitRequestReset = false;
            });
          }
        },
        child: waitRequestReset == false
            ? Text(
                btnTexte.toUpperCase(),
                style: GoogleFonts.roboto(color: Colors.white),
              )
            : const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ));
  }
}
