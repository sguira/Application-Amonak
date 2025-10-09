import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/publication/details_publication.dart';
import 'package:application_amonak/interface/publication/videoPlayerWidget.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/circular_progressor.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/error_snackbar.dart';
import 'package:application_amonak/widgets/imageSkeleton.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/share_widget.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ItemPublication extends StatefulWidget {
  final Publication pub;
  final String? type;
  final PublicationSocket? publicationSocket;

  const ItemPublication(
      {super.key, required this.pub, this.publicationSocket, this.type});

  @override
  State<ItemPublication> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ItemPublication> {
  bool isLike = false;
  int nbLike = 0;
  int nbComment = 0;
  late String idLike;
  late PublicationSocket publicationSocket;
  late Notificationsocket notificationsocket;
  bool waitShare = false;
  bool loading = false;
  bool wantedShare = false;
  String currentPubToShare = "";
  TextEditingController shareMessage = TextEditingController();
  List<ArticleModel> articles = [];
  ArticleModel? articleSelected = null;
  final responseAlerteKey = GlobalKey<FormState>();
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
    articles = getPublication();
    publicationSocket = PublicationSocket();

    notificationsocket = Notificationsocket();

    publicationSocket.socket!.onConnect((handler) {
      print("Socket publication connecté");
    });

    print("type de ma publication !!!!!!!!${widget.type}");

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

  List<String> colors = ["Rouge", "Noir", "Blanc", "Gris", "Orange", "Marron"];
  List<String> sizes = ["XS", "L", "M", "X"];
  List<String> colorSeledted = [];
  List<String> sizeSlect = [];

  addColors(String item) {
    setState(() {
      if (colorSeledted.contains(item)) {
        int index = colorSeledted.indexOf(item);
        colorSeledted.remove(item);
      } else {
        colorSeledted.add(item);
      }
    });
  }

  addSize(String item) {
    setState(() {
      print(item);
      if (sizeSlect.contains(item)) {
        print("container");
        int index = sizeSlect.indexOf(item);
        sizeSlect.remove(item);
      } else {
        sizeSlect.add(item);
      }
    });
  }

  itemSelect(String title, String type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: type == 'color'
              ? (colorSeledted.contains(title) ? couleurPrincipale : null)
              : (sizeSlect.contains(title) ? couleurPrincipale : null),
          border: Border.all(
            width: 0.5,
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(18)),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 10,
          color: type == 'color'
              ? (colorSeledted.contains(title) ? Colors.white : null)
              : (sizeSlect.contains(title) ? Colors.white : null),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: ScreenSize.width*0.9,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.blue.withAlpha(5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: .5, color: Colors.black.withAlpha(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              headerBoutiquecustom(
                  user: widget.pub.user!,
                  dateCreation: widget.pub.dateCreation!,
                  style: 1,
                  typeLateralBtn: "",
                  context: context),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      //  shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(11)
                      //  ),
                      builder: (context) =>
                          DetailsPublication(pubId: widget.pub.id!));
                },
                child: bodyContainer(widget.pub),
              ),
              footerContainer(widget.pub)
            ],
          ),
        ),
      ],
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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(11),

      // ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(1),
          child: image != ''
              ? LoadImage(
                  imageUrl: image!,
                  width: ScreenSize.width * 0.9,
                  height: ScreenSize.width * 0.9,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/medias/profile.jpg",
                  fit: BoxFit.cover,
                )),
    );
  }

  footerContainer(Publication publication) {
    return Container(
      // margin: ,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
                      elevation: 10,
                      showDragHandle: true,
                      enableDrag: true,
                      builder: (context) => CommentaireWidget(
                            pubId: publication.id,
                            pub: publication,
                          ));
                },
                child: itemDescription(nbComment.toString(), "Commentaires"),
              ),
              widget.pub.type != 'alert'
                  ? itemDescription("0", "Partages")
                  : Center(),
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
              Container(
                child: IconButton(
                    onPressed: () {
                      // zoneCommentaire(context, pub, pubId)
                      showCustomModalSheetWidget(
                          context: context,
                          child: DetailsPublication(pubId: widget.pub.id!));
                    },
                    icon: const Icon(Icons.comment)),
              ),
              if (widget.type != 'alerte') shareIcon(Icons.repeat),
              if (widget.type == 'alerte')
                Container(
                  child: TextButton(
                      onPressed: () {
                        articleSelected = null;
                        widgetResponseAlerte(widget.pub);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: couleurPrincipale,
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 1)),
                      child: Text(
                        'Répondre',
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      )),
                )
            ],
          )
        ],
      ),
    );
  }

  getPublication() {
    List<ArticleModel> articles = [];
    ProductService.getSingleArticle(userId: DataController.user!.id)
        .then((value) => {
              if (value.statusCode == 200)
                {
                  for (var a in jsonDecode(value.body))
                    {
                      setState(() {
                        articles.add(ArticleModel.fromJson(a)!);
                      })
                    }
                }
            });
    return articles;
  }

  widgetResponseAlerte(Publication pub) async {
    TextEditingController messageAlerte = TextEditingController();
    TextEditingController nomArticle = TextEditingController();
    TextEditingController montant = TextEditingController();
    TextEditingController livraison = TextEditingController();
    TextEditingController taille = TextEditingController();
    TextEditingController numero = TextEditingController();
    TextEditingController articleId = TextEditingController();
    Map<String, String> articleChoiceId = {"id": "", "value": ""};
    InputDecoration decoration({String? hintText, IconData? leading}) =>
        InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(
                fontSize: 12, color: Colors.black.withAlpha(150)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: Colors.black54,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: couleurPrincipale,
              ),
            ),
            prefixIcon: Icon(
              leading,
              size: 18,
              color: Colors.black45,
            ));

    return await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState_) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(2))),
                title: Form(
                  key: responseAlerteKey,
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          "Envoyez un message",
                          style: GoogleFonts.roboto(
                              color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatefulBuilder(builder: (context, S) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            child: TextFormField(
                              controller: articleId,
                              onTap: () async {
                                await choiceArticleContainer(
                                    context, articleChoiceId, S, articleId);
                                setState_(() {
                                  articleSelected =
                                      getArticleById(articleId.text);
                                });
                                if (articleSelected != null) {
                                  setState_(() {
                                    articleSelected =
                                        getArticleById(articleId.text);
                                    nomArticle.text = articleSelected!.name!;
                                    montant.text =
                                        articleSelected!.price.toString();
                                    numero.text = articleSelected!.user!.phone!;
                                    livraison.text = NumberFormat.currency(
                                            locale: 'fr',
                                            symbol: articleSelected!.currency ??
                                                'CFA')
                                        .format(articleSelected!.livraison);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Choisir l\'article',
                                hintStyle: GoogleFonts.roboto(fontSize: 12),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    await choiceArticleContainer(
                                        context, articleChoiceId, S, articleId);
                                  },
                                  icon: const Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                          );
                        }),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: TextFormField(
                            controller: nomArticle,
                            validator: (value) {
                              if (nomArticle.text.isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              return null;
                            },
                            decoration: decoration(
                              hintText: 'Nom article',
                              leading: Icons.library_books,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: TextFormField(
                            controller: montant,
                            validator: (value) {
                              if (montant.text.isEmpty) {
                                return 'Le montant est obligatoire';
                              }
                              return null;
                            },
                            decoration: decoration(
                                hintText: 'Montant article',
                                leading: Icons.payment),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: TextFormField(
                            controller: livraison,
                            validator: (value) {
                              if (livraison.text.isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              return null;
                            },
                            decoration: decoration(
                                hintText: 'Livraison',
                                leading: Icons.directions_bike),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: TextFormField(
                            controller: numero,
                            validator: (value) {
                              if (taille.text.isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              return null;
                            },
                            decoration: decoration(
                                hintText: 'Téléphone',
                                leading: Icons.smartphone),
                          ),
                        ),
                        MultiSelect(
                            reload: setState_,
                            listes: sizes,
                            title: "Tailles disponibles",
                            add: addSize,
                            type: 'size'),
                        MultiSelect(
                            reload: setState_,
                            listes: colors,
                            title: "Couleur disponible",
                            add: addColors,
                            type: 'color'),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: articleSelected != null
                                          ? couleurPrincipale
                                          : Colors.grey),
                                  onPressed: articleSelected == null
                                      ? null
                                      : () {
                                          if (responseAlerteKey.currentState!
                                              .validate()) {
                                            setState_(() {
                                              loading = true;
                                            });
                                            MessageModel messageModel =
                                                MessageModel();
                                            String content =
                                                """J'ai cet article ${nomArticle.text} disponible En taille ${formatSize(sizeSlect)} avec les couleurs ${formatSize(colorSeledted)} au prix de ${NumberFormat.currency(locale: 'fr', symbol: '', decimalDigits: 0).format(double.parse(montant.text ?? '0'))} vous pouvez me contacter au numéro ${numero.text} pour plus d'information. \$*${articleSelected!.id} """;
                                            messageModel.content = content;
                                            messageModel.articleId =
                                                articleChoiceId["id"];
                                            messageModel.to = pub.user!.id;
                                            messageModel.publication =
                                                articleSelected;
                                            messageModel.type = "alerte";
                                            messageModel.from =
                                                DataController.user!.id;

                                            MessageService.sendMessage(
                                                    message: messageModel)
                                                .then((value) {
                                              setState_(() {
                                                loading = false;
                                              });
                                              if (value.statusCode == 200) {
                                                Navigator.pop(context);
                                                setState_(() {
                                                  loading = false;
                                                });
                                                print("Response ${value.body}");
                                                successSnackBar(
                                                    message: 'Réponse envoyée',
                                                    context: context);
                                              }
                                              setState_(() {
                                                loading = false;
                                              });
                                            });
                                          }
                                        },
                                  child: loading == false
                                      ? Text(
                                          'Répondre',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      : circularProgression(
                                          color: Colors.white))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  getArticleById(String id) {
    print("List des articles:${articles.length} ");
    for (var item in articles) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<dynamic> choiceArticleContainer(
      BuildContext context,
      Map<String, String> articleChoiceId,
      StateSetter S,
      TextEditingController articleId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: 0.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      builder: (context) => StatefulBuilder(builder: (context, setState_) {
        return Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Container(
                child: const Text("Choisissez un article"),
              ),
              Expanded(
                child: articles.isNotEmpty
                    ? ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ItemListArticle(
                                                  label: "Nom",
                                                  value: articles[index].name!),
                                              ItemListArticle(
                                                  label: "Prix",
                                                  value: articles[index]
                                                      .price
                                                      .toString()),
                                              ItemListArticle(
                                                  label: "Disponible",
                                                  value: articles[index]
                                                      .qte
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // const Spacer(),
                                            const SizedBox(
                                              height: 26,
                                            ),
                                            Container(
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: articleChoiceId["id"] !=
                                                        articles[index].id!
                                                    ? couleurPrincipale
                                                    : Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(26),
                                              ),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      S(() {
                                                        setState_(() {
                                                          articleChoiceId[
                                                                  'id'] =
                                                              articles[index]
                                                                  .id!;
                                                          articleChoiceId[
                                                                  "value"] =
                                                              articles[index]
                                                                  .name!;
                                                          articleId.text =
                                                              articleChoiceId[
                                                                  "id"]!;
                                                        });
                                                      });
                                                      articleSelected =
                                                          getArticleById(
                                                              articleChoiceId[
                                                                  "id"]!);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  style: const ButtonStyle(
                                                      // backgroundColor: Colors.red,
                                                      ),
                                                  child: Text(
                                                    "Choisir",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 11,
                                                        color: articleChoiceId[
                                                                    "id"] !=
                                                                articles[index]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                    : Container(
                        child: Column(
                          children: [
                            Text(
                                "Vous avez publier aucun article en vente jusqu'a present")
                          ],
                        ),
                      ),
              )
            ],
          ),
        );
      }),
    );
  }

  // Modification de la fonction pour accepter des couleurs optionnelles
  Container ItemListArticle({
    required String label,
    required String value,
    Color? labelColor, // Nouveau paramètre
    Color? valueColor, // Nouveau paramètre
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 0), // Enlevez le margin pour le contrôle dans la Row
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: labelColor ??
                  couleurPrincipale, // Utilisation de la couleur passée
            ),
          ),
          const SizedBox(height: 2), // Petit espacement vertical
          SizedBox(
            width:
                70, // Contrainte de largeur ajustée (peut être enlevée si vous préférez)
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 12, // Taille légèrement plus grande
                fontWeight: FontWeight.w300, // Mettre la valeur en gras
                color: valueColor ??
                    Colors.black, // Utilisation de la couleur passée
              ),
              overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
    );
  }

  formatSize(List<String> size) {
    String out = "";
    for (String i in size) {
      out += '${i} ';
    }
    return out;
  }

  Container MultiSelect({
    required String title,
    required List<String> listes,
    required Function add,
    required String type,
    required reload,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      // decoration: BoxDecoration(color: Colors.black12),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
                color: Colors.black.withAlpha(120), fontSize: 12),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              for (var i in listes)
                GestureDetector(
                  onTap: () {
                    reload(() {
                      add(i);
                    });
                  },
                  child: itemSelect(i, type),
                )
            ],
          ),
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

  Widget shareIcon(IconData icon) => InkWell(
        onTap: () {
          setState(() {
            if (wantedShare == false) {
              showCustomModalSheetWidget(
                  context: context,
                  child: ShareWidget(
                    itemPub: widget.pub,
                  ));
            } else {
              wantedShare = false;
            }
          });
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              icon,
              size: 22,
            )),
      );

  sharePublication(Publication pub) {
    Publication sharePub = pub;

    sharePub.share = DataController.user!.id;
    sharePub.shareMessage = shareMessage.text;

    // PublicationService.
  }

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
