import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home_tab_menu.dart';
import 'package:application_amonak/interface/accueils/welcome.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/auths.dart';
import 'package:application_amonak/services/notificationService.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:application_amonak/services/socket/commentSocket.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationLocalService.initialize();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Notificationsocket notificationsocket;
  bool isAuth = false;
  bool loading = true;
  veriticationUserIsConnect() async {
    await LocalStorage.getToken().then((value) {
      if (value != null) {
        tokenValue = value;
      }
    }).catchError((e) {
      setState(() {
        loading = false;
        isAuth = false;
      });
    });

    try {
      if (tokenValue != null) {
        await LocalStorage.getDateTokenTimeout().then((value) {
          if (value != null) {
            print("La date est ${value}");
            if (DateTime.parse(value).isAfter(DateTime.now())) {
              // loadData();
              print("Le token est valide");
              LocalStorage.getUserId().then((value) async {
                print("L'id de l'utilisateur est $value");
                if (value != null) {
                  UserService.getUser(userId: value).then((value) {
                    if (value.statusCode == 200) {
                      DataController.user =
                          User.fromJson(jsonDecode(value.body));
                      print("ok ok");
                      setState(() {
                        isAuth = true;
                        loading = false;
                      });
                    }
                    UserService.getAllUser(param: {}).then((value) {
                      if (value.statusCode == 200) {
                        DataController.friends = [];
                        for (var user in jsonDecode(value.body) as List) {
                          DataController.friends.add(User.fromJson(user));
                        }
                      }
                    }).catchError((e) {
                      print("Erreur lors du chargement des utilisateurs : $e");
                    });
                  });
                }
              }).catchError((e) {
                setState(() {
                  loading = false;
                  isAuth = false;
                });
              });
            } else {
              setState(() {
                loading = false;
                isAuth = false;
              });
            }
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          loading = false;
          isAuth = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        isAuth = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // notificationsocket=Notificationsocket();
    veriticationUserIsConnect();
  }

  @override
  void dispose() {
    notificationsocket.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;
    return MaterialApp(
        navigatorKey: NotificationLocalService.navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routes: {'/home': (context) => const HomePageTab()},
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: loading == true
            ? const Loading()
            : !isAuth
                ? const WelcomePage()
                : const HomePageTab());
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/icons/amonak.png",
                  width: 200, height: 100),
            ),
            Container(
              child: LoadingAnimationWidget.newtonCradle(
                color: couleurPrincipale,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
