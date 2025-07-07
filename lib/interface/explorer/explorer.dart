import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/articles/list_article.dart';
import 'package:application_amonak/interface/explorer/boutique.dart';
import 'package:application_amonak/interface/explorer/personne.dart';
import 'package:application_amonak/interface/publication/publication.dart';
import 'package:application_amonak/interface/profile/publication_widget.dart';
import 'package:application_amonak/interface/publication/puclicationNotifierPage.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  List<User> users = [];
  List<Publication> publications = [];

  fetchAllData() async {
    await [loadUser(), loadPublication()];
  }

  loadUser() async {
    await UserService.getAllUser(param: {})
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
      print("Unnnnnnnnnnnnnnnnne erreur $e");
    });
  }

  loadPublication() async {
    await PublicationService.getPublications(
            userId: DataController.user!.id, limite: 7)
        .then((value) async {
      print("Status code : ${value.statusCode}");
      print("liste des publication ${value.body}");
      publications = [];
      if (value.statusCode.toString() == '200') {
        for (var item in jsonDecode(value.body) as List) {
          if (item['type'] != null) {
            if (item['type'] != null) {
              Publication pub = Publication.fromJson(item);
              publications.add(pub);
            }
            if (item['type'] == 'share') {
              if (item['share'] != null) {
                await PublicationService.getPublicationById(id: item['share'])
                    .then((value) {
                  if (value.statusCode == 200) {
                    Publication pub =
                        Publication.fromJson(jsonDecode(value.body));
                    pub.share = item['share'];
                    pub.userShare = User.fromJson(item['user']);
                    pub.shareDate = DateTime.parse(item['createdAt']);
                    pub.shareMessage = item['shareMessage'];
                    publications.add(pub);
                  }
                }).catchError((e) {
                  print("Unnnnnnnnnnnnnnnnne erreur $e");
                });
              }
            }
          }
        }
      }
      return "";
    }).catchError((e) {
      print("error: $e\n\n");
      print("Unnnnnnnnnnnnnnnnne erreur $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAllData(),
        builder: (context, snapshot) {
          return Scaffold(
            body: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  // header(),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(left: 8, right: 8, top: 6),
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/icons/amonak.png",
                                width: 100,
                              ),
                              const ButtonNotificationWidget()
                            ],
                          ),
                        ),
                        Expanded(
                          child: Scaffold(
                            appBar: AppBar(
                              // leading: Container(
                              //   child:const Column(
                              //     children: [
                              //       Text("Nous dévenons ce que nous pensons")
                              //     ],
                              //   ),
                              // ),
                              toolbarHeight: 0,
                              automaticallyImplyLeading: false,
                              // excludeHeaderSemantics: true,
                              // leading: header(),
                              // flexibleSpace: header(),
                              bottom: TabBar(tabs: [
                                itemTabBar("Personne"),
                                itemTabBar("Article"),
                                itemTabBar("Boutique"),
                                itemTabBar("Publication"),
                                itemTabBar("Alerte"),
                              ]),
                            ),
                            body: const TabBarView(children: [
                              ListePersonnePage(),
                              Article(),
                              BoutiquePage(),
                              PublicationPage2(
                                type: 'default',
                                // publications: publications,
                              ),
                              PublicationPage(
                                type: 'alerte',
                                // publications: publications,
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  header() {
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
            ),
          )
        ],
      ),
    );
  }

  Tab itemTabBar(String label) {
    return Tab(
        // height: 22,
        iconMargin: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          // width: 100,
          child: Text(
            label,
            style: GoogleFonts.roboto(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  itemArticle(String label) {
    return Container(
      child: Text(label),
    );
  }
}
