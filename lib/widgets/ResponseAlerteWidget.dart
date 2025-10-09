import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/widgets/circular_progressor.dart';
import 'package:application_amonak/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ResponseAlerteWidget extends StatefulWidget {
  final Publication publication;
  const ResponseAlerteWidget({super.key, required this.publication});

  @override
  State<ResponseAlerteWidget> createState() => _ResponseAlerteWidgetState();
}

class _ResponseAlerteWidgetState extends State<ResponseAlerteWidget> {
  final GlobalKey<FormState> responseAlerteKey = GlobalKey<FormState>();

  ArticleModel? articleSelected;
  List<ArticleModel> articles = [];
  bool loading = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articles = getPublication();
  }

  @override
  Widget build(BuildContext context) {
    return widgetResponseAlerte(widget.publication);
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

  widgetResponseAlerte(Publication pub) {
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
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
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
                      setState(() {
                        articleSelected = getArticleById(articleId.text);
                      });
                      if (articleSelected != null) {
                        setState(() {
                          articleSelected = getArticleById(articleId.text);
                          nomArticle.text = articleSelected!.name!;
                          montant.text = articleSelected!.price.toString();
                          numero.text = articleSelected!.user!.phone!;
                          livraison.text = NumberFormat.currency(
                                  locale: 'fr',
                                  symbol: articleSelected!.currency ?? 'CFA')
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
                      hintText: 'Montant article', leading: Icons.payment),
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
                      hintText: 'Livraison', leading: Icons.directions_bike),
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
                      hintText: 'Téléphone', leading: Icons.smartphone),
                ),
              ),
              MultiSelect(
                  reload: setState,
                  listes: sizes,
                  title: "Tailles disponibles",
                  add: addSize,
                  type: 'size'),
              MultiSelect(
                  reload: setState,
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
                                  setState(() {
                                    loading = true;
                                  });
                                  MessageModel messageModel = MessageModel();
                                  String content =
                                      """J'ai cet article ${nomArticle.text} disponible En taille ${formatSize(sizeSlect)} avec les couleurs ${formatSize(colorSeledted)} au prix de ${NumberFormat.currency(locale: 'fr', symbol: '', decimalDigits: 0).format(double.parse(montant.text ?? '0'))} vous pouvez me contacter au numéro ${numero.text} pour plus d'information. \$*${articleSelected!.id} """;
                                  messageModel.content = content;
                                  messageModel.articleId =
                                      articleChoiceId["id"];
                                  messageModel.to = pub.user!.id;
                                  messageModel.publication = articleSelected;
                                  messageModel.type = "alerte";
                                  messageModel.from = DataController.user!.id;

                                  MessageService.sendMessage(
                                          message: messageModel)
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                    if (value.statusCode == 200) {
                                      Navigator.pop(context);
                                      setState(() {
                                        loading = false;
                                      });
                                      print("Response ${value.body}");
                                      successSnackBar(
                                          message: 'Réponse envoyée',
                                          context: context);
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }
                              },
                        child: loading == false
                            ? Text(
                                'Répondre',
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 12),
                              )
                            : circularProgression(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                fontWeight: FontWeight.bold, // Mettre la valeur en gras
                color: valueColor ??
                    couleurPrincipale
                        .withAlpha(180), // Utilisation de la couleur passée
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
}
