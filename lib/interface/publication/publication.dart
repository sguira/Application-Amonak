import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart';
import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/interface/publication/image_container.dart';
import 'package:application_amonak/interface/publication/videoPlayerWidget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/header_publication.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'package:popover/popover.dart';
class PublicationPage extends StatefulWidget {
  final String? type;
  final String? userId;
  final bool? hideLabel;
  final List<Publication>? publications;
  const PublicationPage(
      {super.key, this.type, this.userId, this.hideLabel, this.publications});

  @override
  State<PublicationPage> createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  List<Publication> publication = [];

  late int nbLike = 0;
  late bool isLiked = false;
  TextEditingController search = TextEditingController();
  String type = '';

  late Future<dynamic> loadDataResult;

  // IO.Socket? socket;

  late PublicationSocket publicationSocket;
  late Notificationsocket notificationsocket;

  // PublicationSocket? publicationSocket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    publicationSocket = PublicationSocket();
    notificationsocket = Notificationsocket();
    print("Type de publication ${widget.type}");
    publicationSocket.socket!.on("likePublicationListener", (handler) {
      print("La publication a été  liké");
    });
    publicationSocket.socket!.on("newPublicationListener", (handler) {});
    //recevoir des notification
    notificationsocket.socket!.on("refreshNotificationBoxHandler", (handler) {
      print("Une nouvelle notification < $handler \n\n\n");
    });
    loadDataResult = loadData();
    // initSocket();
  }

  loadData() async {
    if (widget.publications != null) {
      print("taille des pub ${widget.publications!.length}");
      setState(() {
        publication = widget.publications!;
      });
      // return null;
    }
    await PublicationService.getPublications(userId: widget.userId, limite: 7)
        .then((value) async {
      print("Status code : ${value.statusCode}");
      print("liste des publication ${value.body}");
      publication = [];
      if (value.statusCode.toString() == '200') {
        for (var item in jsonDecode(value.body) as List) {
          if (item['type'] != null) {
            if (widget.type == item['type']) {
              Publication pub = Publication.fromJson(item);

              publication.add(pub);
            }
            if (item['type'] == 'share' && widget.type != 'alerte') {
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
                    publication.add(pub);
                  }
                }).catchError((e) {});
              }
            }
          }
        }
      }
      return "";
    }).catchError((e) {
      print("error: $e\n\n");
    });
  }

  getNombreLike() async {
    // await PublicationService.getNumberLike(widget., type)
  }

  @override
  void dispose() {
    publicationSocket.socket!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadDataResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitWidget();
          }
          if (snapshot.hasError) {
            return Container(
                margin: const EdgeInsets.symmetric(vertical: 22),
                child: const Center(child: Text('Error')));
          }
          return publication.isNotEmpty
              ? StatefulBuilder(builder: (context, setState_) {
                  return Column(
                    children: [
                      header(setState_),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            // alignment: WrapAlignment.center,
                            itemCount: publication.length,
                            shrinkWrap: true,

                            scrollDirection: Axis.vertical,

                            itemBuilder: (context, index) {
                              return publication[index].share == null
                                  ? ItemPublication(
                                      pub: publication[index],
                                      type: widget.type,
                                      publicationSocket: publicationSocket,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                              child: HeaderPublication(
                                                  style: 1,
                                                  dateCreation:
                                                      publication[index]
                                                          .shareDate!,
                                                  context: context,
                                                  user: publication[index]
                                                      .userShare!)),
                                          TextExpanded(
                                              texte: publication[index]
                                                  .shareMessage!),
                                          Container(
                                              padding: const EdgeInsets.all(8),
                                              child: ItemPublication(
                                                  pub: publication[index],
                                                  publicationSocket:
                                                      publicationSocket)),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                })
              : const AucunElement(
                  label: "Aucune publication",
                );
        });
  }

  bodyContainer(Publication item) {
    return Column(
      children: [
        textContainer(item.content!),
        if (item.files.isNotEmpty && item.files[0].url != '')
          item.files[0].type == 'image'
              ? imageContaint(item.files[0].url)
              : VideoPlayerWidget2(url: item.files[0].url!)
      ],
    );
  }

  textContainer(String texte) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: ScreenSize.width * 0.8,
      // height: 80,
      constraints: const BoxConstraints(maxHeight: 80),
      child: Text(
        texte,
        textAlign: TextAlign.start,
        style: GoogleFonts.roboto(fontSize: 12),
        overflow: TextOverflow.fade,
      ),
    );
  }

  imageContaint(String? image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(11),

      // ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: image != ''
              ? Image.network(
                  image!,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/medias/profile.jpg",
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    );
                  },
                )
              : Image.asset(
                  "assets/medias/user.jpg",
                  fit: BoxFit.cover,
                )),
    );
  }

  footerContainer(Publication publication) {
    return Container(
      // margin: ,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              itemDescription("100", "Likes"),
              GestureDetector(
                onTap: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) => CommentaireWidget(
                          pubId: publication.id, pub: publication));
                },
                child: itemDescription("5000", "Commentaires"),
              ),
              itemDescription("10000", "Partages"),
            ],
          ),
          Row(
            children: [
              buttonIcon(Icons.favorite_border),
              buttonIcon(Icons.comment),
              buttonIcon(Icons.repeat)
            ],
          )
        ],
      ),
    );
  }

  header(dynamic setState_) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.red
      // ),
      // height: 8,
      // margin: EdgeInsets.only(top: 22),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.hideLabel != true)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                "\" NOUS DEVENONS CE QUE NOUS PENSONS \"",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          Container(
            width: 280,
            height: 42,
            margin: const EdgeInsets.symmetric(vertical: 12),
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
                  PublicationService.getPublications(search: search.text)
                      .then((value) {
                    print("values status code search:${value.statusCode}");
                    if (value.statusCode == 200) {
                      setState_(() {
                        publication = [];
                        for (var item in jsonDecode(value.body) as List) {
                          publication.add(Publication.fromJson(item));
                        }
                      });
                    }
                  }).catchError((e) {
                    print("Error $e");
                    PublicationService.getPublications().then((value) {
                      if (value.statusCode == 200) {
                        setState_(() {
                          publication = [];
                          for (var item in jsonDecode(value.body) as List) {
                            publication.add(Publication.fromJson(item));
                          }
                        });
                      }
                    });
                  });
                } else {
                  PublicationService.getPublications().then((value) {
                    if (value.statusCode == 200) {
                      setState_(() {
                        publication = [];
                        for (var item in jsonDecode(value.body) as List) {
                          publication.add(Publication.fromJson(item));
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

  Container buttonIcon(IconData icon) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Icon(
        icon,
        size: 28,
      ));

  itemDescription(String value, String label) {
    return Container(
      // width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Text(
            NumberFormat.compact(
              locale: 'fr',
            ).format(int.parse(value)),
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(
            width: 2,
          ),
          SizedBox(
              width: 32,
              child: Text(
                label,
                style: GoogleFonts.roboto(fontSize: 9),
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }

  headerBoutique(User item, int style) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(86), color: Colors.black12),
            child: ClipOval(
                child: Image.asset(
              'assets/medias/user.jpg',
              width: 45,
              fit: BoxFit.cover,
            )),
          ),
          Column(
            children: [
              Text(
                item.userName!,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              // style!=1?
              // Text(item['type'],style: GoogleFonts.roboto(fontSize: 10),):Container()
            ],
          ),
          Container(
            child: PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: () {
                                alerteSuppression(item.id!);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.delete),
                                  Text('Supprimer'),
                                ],
                              )))
                    ]),
          )
        ],
      ),
    );
  }

  alerteSuppression(String id) {
    Navigator.pop(context);
    bool wait = false;
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState_) {
              return AlertDialog(
                title: Text("Confirmer la suppression",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: Container(
                  child: Text(
                    "Cette action aura pour consequence la suppression de la publication",
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Annuler')),
                  TextButton(
                      onPressed: () {
                        setState_(() {
                          wait = true;
                        });
                        PublicationService.suppression(id).then((value) {
                          setState_(() {
                            wait = false;
                          });
                          print("status Code $value\n\n\n");
                          if (value.toString() != '200') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'La publication a été supprimé!')));
                            setState(() {});
                          }
                          setState(() {
                            deleteLocal(id);
                          });
                          Navigator.pop(context);
                        }).catchError((e) {
                          print("ERROR $e");
                        });
                      },
                      child: wait == false
                          ? const Text('Confirmer')
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: const CircularProgressIndicator(
                                strokeWidth: 1,
                              )))
                ],
              );
            }));
  }

  deleteLocal(String id) {
    publication = [];
    for (Publication i in publication) {
      if (i.id != id) {
        publication.add(i);
      }
    }
  }

  deletePublication(String id) {}
}
