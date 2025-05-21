import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/publication/details_item_pub.dart';
import 'package:application_amonak/interface/publication/image_container.dart';
import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailsPublication extends StatefulWidget {
  final String pubId;
  const DetailsPublication({super.key, required this.pubId});

  @override
  State<DetailsPublication> createState() => _DetailsPublicationState();
}

class _DetailsPublicationState extends State<DetailsPublication>
    with AutomaticKeepAliveClientMixin {
  late Future<String> loadData;
  late Publication pub;

  late PublicationSocket publicationSocket;
  late List<Commentaire> commentaires = [];

  late List<String> dropDownList;
  late String currentDropDownValue;

  TextEditingController commentText = TextEditingController();

  Future<String> loadPub(int limite) async {
    return await PublicationService.getPublicationById(id: widget.pubId)
        .then((value) async {
      if (value.statusCode == 200) {
        setState(() {
          pub = Publication.fromJson(jsonDecode(value.body));
        });
        await CommentaireService.getCommentByPublication(
                pubId: widget.pubId, limite: limite)
            .then((value) {
          if (value.statusCode == 200) {
            commentaires = [];
            for (var item in jsonDecode(value.body) as List) {
              setState(() {
                commentaires.add(Commentaire.fromJson(item));
              });
            }
          }
        });
        print(value.body);
      }
      return "Bien chargé";
    }).catchError((e) {
      print(e);
      return "Erreur de chargement";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData = loadPub(5);

    publicationSocket = PublicationSocket();

    dropDownList = ["Plus récents", "Tous les commentaire", "Mes commentaires"];
    currentDropDownValue = dropDownList.first;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                Skeletonizer.zone(
                  child: Card(
                    child: ListTile(
                      leading: Bone.circle(size: 48),
                      title: Bone.text(words: 2),
                      subtitle: Bone.text(),
                      trailing: Bone.icon(),
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            const Column(
              children: [Text("Une erreur est survenue")],
            );
          }
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: ListView(
                children: [
                  Container(
                    child: DetailsItemPubliction(
                        pub: pub, publicationSocket: publicationSocket),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 4),
                              // height: 42,
                              child: TextFormField(
                                controller: commentText,
                                minLines: 1,
                                maxLines: 5,
                                onChanged: (value) {
                                  setState(() {
                                    commentText.text = value;
                                  });
                                },
                                style: GoogleFonts.roboto(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Votre Commentaire',
                                  hintStyle: GoogleFonts.roboto(fontSize: 13),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12)),
                                ),
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            // transitionBuilder: (child, animation) => ,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    border: Border.all(
                                        color:
                                            couleurPrincipale.withAlpha(60))),
                                child: commentText.text.isNotEmpty &&
                                        commentText.text.isBlank == false
                                    ? IconButton(
                                        onPressed: () {
                                          Commentaire com = Commentaire();
                                          com.content = commentText.text;
                                          com.userId = DataController.user!.id;
                                          com.publicationId = widget.pubId;
                                          com.isLike = false;
                                          Map<String, dynamic>
                                              notificationData = {
                                            'publication': widget.pubId,
                                            'from': DataController.user!.id,
                                            'to': pub.user!.id,
                                            'type': 'comment'
                                          };

                                          CommentaireService.saveComent(com)
                                              .then((value) {
                                            if (value.statusCode == 200) {
                                              setState(() {
                                                setState(() {
                                                  commentaires.insert(
                                                      0,
                                                      Commentaire.fromJson(
                                                          jsonDecode(
                                                              value.body)));
                                                  commentaires[0].isLike =
                                                      false;
                                                });
                                              });
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.send_rounded,
                                          color: couleurPrincipale,
                                          size: 22,
                                        ))
                                    : null),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 18, left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Les commentaires",
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: couleurPrincipale),
                          ),
                        ),
                        Container(
                          // height: 80,
                          // width: 120,
                          child: DropdownButton(
                              elevation: 0,
                              focusColor: Colors.white10,
                              style: GoogleFonts.roboto(
                                  fontSize: 12, color: Colors.black),
                              value: currentDropDownValue,
                              items: dropDownList.map((String ele) {
                                return DropdownMenuItem(
                                    value: ele, child: Text(ele));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  currentDropDownValue = value!;
                                  if (currentDropDownValue ==
                                      dropDownList.first) {
                                    setState(() {
                                      loadPub(5);
                                    });
                                  }
                                  if (currentDropDownValue == dropDownList[1]) {
                                    loadPub(1000);
                                  }
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 18),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var item in commentaires)
                              ItemCommentaire(
                                  com: item,
                                  setState_: () {},
                                  pubId: widget.pubId)
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
