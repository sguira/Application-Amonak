import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/accueils/welcome.dart';
import 'package:application_amonak/local_storage.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/widgets/item_notification.dart';
import 'package:application_amonak/widgets/list_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GestionProfilePage extends StatefulWidget {
  const GestionProfilePage({super.key});

  @override
  State<GestionProfilePage> createState() => _GestionProfilePageState();
}

class _GestionProfilePageState extends State<GestionProfilePage> {
  // List<NotificationModel> notifications=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context: context, title: ''),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "gérer ma boutique".toUpperCase(),
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                      tabs: [itemTab("portefeuille"), itemTab("statistique")]),
                ),
                body: PageView(
                  children: [Container(), Container()],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  alerteDeconnexio() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Déconnexion",
              style: GoogleFonts.roboto(fontSize: 16, color: couleurPrincipale),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: couleurPrincipale),
            )
          ],
        ),
        content: Container(
          child: Text(
            "Voulez-vous vous déconnecter de l'application ?",
            style: GoogleFonts.roboto(fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Non",
              style: GoogleFonts.roboto(),
            ),
          ),
          TextButton(
            onPressed: () {
              LocalStorage.removeData().then((value) {
                if (value != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                }
              });
            },
            child: Text(
              "Oui",
              style: GoogleFonts.roboto(),
            ),
          )
        ],
      ),
    );
  }

  AppBar customAppBar({required BuildContext context, String? title}) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
          )),
      title: title != null
          ? Container(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      alerteDeconnexio();
                    },
                    child: Text(
                      'Se déconnecter'.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 11, decoration: TextDecoration.underline),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Editer'.toUpperCase().toUpperCase(),
                      style: GoogleFonts.roboto(fontSize: 11),
                    ))
              ],
            ))
          : null,
      centerTitle: false,
    );
  }

  Tab itemTab(String label) => Tab(
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.roboto(fontSize: 12),
        ),
      );
}
