import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/connection/activation.dart';
import 'package:application_amonak/interface/connection/create_user.dart';
import 'package:application_amonak/interface/connection/reset_password.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/auth.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/item_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  bool wailLoging = false;

  int type = 0;
  //

  bool waitRequestReset = false;
  GlobalKey<FormState> formKeyReset = GlobalKey<FormState>();

  bool showErrorR = false;
  String messageR = "";

  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  Notificationsocket? notificationsocket;

  bool showError = false;
  String errorMessage = 'Problème';

  //login variable
  final logingForm = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // veriticationUserIsConnect();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          height: 420,
          child: StatefulBuilder(builder: (context, setState_) {
            return Container(
              child: ListView(
                children: [
                  // headerBottomSheet(context, 'Authentification'),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Spacer(flex: 2,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Se Connecter",
                                    style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                    width: ScreenSize.width * 0.80,
                                    child: Text(
                                      "Nous sommes content de vous revoir ! Reprenons où les choses se sont arrétées.",
                                      style: GoogleFonts.roboto(fontSize: 13),
                                    ))
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close))
                          ])),
                  Container(
                    child: Form(
                      key: logingForm,
                      child: Column(
                        children: [
                          itemForm(
                              hint: 'Ex. sguira96@gmail.com',
                              label: "Nom d'utilisateur",
                              controller: userName,
                              requiet: true),
                          itemForm(
                              hint: '****',
                              label: "Mot de passe",
                              controller: passWord,
                              requiet: true),
                          const SizedBox(
                            height: 22,
                          ),
                          if (showError == true)
                            widgetErrorAlert(
                                errorMessage, setState_, showError),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showCustomModalSheetWidget(
                                      context: context,
                                      child: const ResetPassword());
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Mot de passe oublié ?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(97, 81, 212, 1),
                                      // Color.fromARGB(255, 9, 51, 189),
                                      Color.fromRGBO(132, 62, 201, 1)
                                    ])),
                                child: TextButton(
                                    style: TextButton.styleFrom(),
                                    onPressed: () {
                                      if (logingForm.currentState!.validate()) {
                                        setState_(() {
                                          wailLoging = !wailLoging;
                                          Auth auth = Auth(
                                              userName: userName.text,
                                              passWord: passWord.text);
                                          Login.authenticated(auth)
                                              .then((value) async {
                                            setState_(() {
                                              wailLoging = false;
                                            });
                                            print(
                                                "\n\n\n valeur retour $value \n\n");
                                            if (value.statusCode != 200) {
                                              if (jsonDecode(
                                                      value.body)['message'] ==
                                                  'validation.accountNotActivate') {
                                                Navigator.pop(context);
                                                showCustomModalSheetWidget(
                                                    context: context,
                                                    child:
                                                        ConfirmCodeActivation(
                                                      email: userName.text,
                                                    ));
                                              } else {
                                                errorMessage =
                                                    "Verifiez vos coordonnées";
                                                setState_(() {
                                                  showError = true;
                                                  Future.delayed(const Duration(
                                                          milliseconds: 3000))
                                                      .then((value) {
                                                    setState_(() {
                                                      showError = false;
                                                    });
                                                  });
                                                });
                                              }
                                            } else {
                                              await saveDataOnLocalStorage(
                                                  token: jsonDecode(value.body)[
                                                      "accessToken"],
                                                  timeout: jsonDecode(
                                                      value.body)["expiresIn"],
                                                  userId: jsonDecode(
                                                          value.body)["user"]
                                                      ["_id"]);
                                              loadData();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePageTab()));
                                            }
                                          }).catchError((e) {
                                            setState_(() {
                                              wailLoging = false;
                                              errorMessage =
                                                  'Un problème est survenue';
                                              showError = true;
                                            });
                                          });
                                        });
                                      }
                                    },
                                    child: Center(
                                        child: wailLoging == false
                                            ? Text(
                                                'Connexion',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white),
                                              )
                                            : const SizedBox(
                                                width: 28,
                                                height: 28,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1.5,
                                                )))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  showCustomModalSheetWidget(
                                      context: context,
                                      child: const CreateAccount());
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Je n'ai pas encore de compte",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                  ),
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
          }),
        ),
      ),
    );
  }

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

  saveDataOnLocalStorage({
    required String token,
    required int timeout,
    required String userId,
  }) async {
    await [
      LocalStorage.saveTokenTimeout(timeout),
      LocalStorage.saveUserId(DataController.user!.id!),
      LocalStorage.saveToken(token)
    ];
  }

  loadData() async {
    return [
      NotificationService.getNotification().then((value) {
        if (value!.statusCode == 200) {
          for (var item in jsonDecode(value.body)) {
            NotificationModel notif = NotificationModel.fromJson(item);
            DataController.notifications.add(notif);
          }
        }
      }),
      UserService.getAllUser(param: {
        'user': DataController.user!.id!,
        'friend': true.toString(),
      }).then((value) {
        print("value status code amis ${value.statusCode}");
        print("Amis :${jsonDecode(value.body)}");
        for (var item in jsonDecode(value.body) as List) {
          DataController.friends.add(User.fromJson(item));
        }
      }).catchError((e) {
        print("Execption amis$e");
      })
    ];
  }
}
