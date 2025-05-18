import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/publication/image_container.dart';
import 'package:application_amonak/interface/publication/videoPlayerWidget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/header_publication.dart';
import 'package:application_amonak/widgets/imageSkeleton.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/share_widget.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DetailsItemPubliction extends StatefulWidget {
  final Publication pub;
  final PublicationSocket publicationSocket;
  const DetailsItemPubliction(
      {super.key, required this.pub, required this.publicationSocket});

  @override
  State<DetailsItemPubliction> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<DetailsItemPubliction> {
  bool isLike = false;
  int nbLike = 0;
  int nbComment = 0;
  late String idLike;
  late PublicationSocket publicationSocket;
  late Notificationsocket notificationsocket;

  getNumberComment() {
    CommentaireService.getCommentByPublication(pubId: widget.pub.id!)
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          nbComment = (jsonDecode(value.body) as List).length;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  getLike() async {
    await PublicationService.getNumberLike(widget.pub.id!, 'like')
        .then((value) {
      if (value!.statusCode.toString() == '200') {
        setState(() {
          nbLike = (jsonDecode(value.body) as List).length;
        });
        print("Nombre de like $nbLike");
        for (var item in jsonDecode(value.body) as List) {
          if (item['user']['_id'] == DataController.user!.id) {
            setState(() {
              isLike = true;
              idLike = item['_id'];
            });
          }
        }
      }
      print("valeurrrr like $isLike");
    }).catchError((e) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLike();
    getNumberComment();

    publicationSocket = PublicationSocket();

    notificationsocket = Notificationsocket();

    publicationSocket.socket!.onConnect((handler) {
      print("Socket publication connecté");
    });

    publicationSocket.socket!.on("likePublicationListener", (data) {
      print("publication liké !!! ");
      print("data like $data");
      if (data['_id'] == widget.pub.id) {
        setState(() {
          getLike();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: ScreenSize.width*0.9,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.2, color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderPublication(
            user: widget.pub.user!,
            style: 1,
            typeLateralBtn: "close",
            context: context,
            dateCreation: widget.pub.dateCreation!,
          ),
          bodyContainer(widget.pub),
          footerContainer(widget.pub)
        ],
      ),
    );
  }

  bodyContainer(Publication item) {
    return Column(
      children: [
        if (item.content!.isNotEmpty) TextExpanded(texte: item.content!),
        if (item.files.isNotEmpty && item.files[0].url != '')
          item.type == 'image'
              ? imageContaint(widget.pub.files[0].url)
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
              ? LoadImage(
                  imageUrl: image,
                  width: ScreenSize.width * 0.9,
                  height: 300,
                  fit: BoxFit.cover,
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
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              itemDescription("$nbLike", "Likes"),
              GestureDetector(
                onTap: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) => CommentaireWidget(
                            pubId: publication.id,
                            pub: publication,
                          ));
                },
                child: itemDescription(nbComment.toString(), "Commentaires"),
              ),
              itemDescription("0", "Partages"),
            ],
          ),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: IconButton(
                      onPressed: () {
                        if (isLike) {
                          deleteLike();
                        } else {
                          likePublication();
                        }
                      },
                      icon: Icon(
                        isLike == false
                            ? Icons.favorite_border
                            : Icons.favorite,
                        size: 22,
                        color: isLike ? Colors.red : Colors.black,
                      ))),
              // Container(
              //   child: IconButton(onPressed: (){
              //     // zoneCommentaire(context, pub, pubId)
              //     onComment();
              //   }, icon:const Icon(Icons.comment)),
              // ),
              buttonIcon(Icons.repeat)
            ],
          )
        ],
      ),
    );
  }

  onComment() {
    print("Commentaire \n\n");
    return showBottomSheet(
        context: context,
        builder: (context) =>
            CommentaireWidget(pubId: widget.pub.id, pub: widget.pub));
  }

  Container buttonIcon(IconData icon) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
          onTap: () {
            showCustomModalSheetWidget(
                context: context, child: ShareWidget(itemPub: widget.pub));
          },
          child: Icon(
            icon,
            size: 22,
          )));

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
                style: GoogleFonts.roboto(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }

  deleteLike() async {
    if (isLike) {
      await PublicationService.deleteLike(idLike).then((value) {
        print("SUppression like ${value.statusCode} .. \n\n");
        setState(() {
          isLike = false;
          nbLike -= 1;
        });
        if (value.statusCode.toString() != '200') {
          setState(() {
            isLike = true;
            nbLike += 1;
          });
        }
      }).catchError((e) {
        setState(() {
          isLike = true;
          nbLike += 1;
        });
      });
    }
  }

  likePublication() async {
    Map data = {
      "publication": widget.pub.id,
      "user": DataController.user!.id,
      "to": widget.pub.user!.id,
      "reason": '',
      "status": true,
      "type": 'like'
    };
    Map notification = {
      'from': DataController.user!.id,
      'to': widget.pub.user!.id,
      'type': 'like',
      // 'content':'publication.LikeYourPublication'
    };
    if (isLike == false) {
      setState(() {
        isLike = true;
        nbLike += 1;
      });
      PublicationService.addLike(data).then((value) {
        print("Status like ${value.statusCode}\n\n");
        if (value.statusCode != 200) {
          print("status code like${value.statusCode}");

          setState(() {
            isLike = false;
            nbLike -= 1;
          });
        } else {
          NotificationService.addNotification(notification);
          Map data = jsonDecode(value.body);
          print("publication $data");
          publicationSocket.socket!
              .emit("likePublicationEvent", {"type": "like", "data": data});
          notificationsocket.socket!.emit("refreshNotificationBox",
              {"from": DataController.user!.id, "to": widget.pub.user!.id});
        }
      }).catchError((e) {
        print("Error like ${e.toString()}");
        setState(() {
          isLike = false;
          nbLike -= 1;
        });
      });
    }
  }
}
