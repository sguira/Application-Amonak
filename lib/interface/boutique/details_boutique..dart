import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/articles/details_article.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsBoutique extends StatefulWidget {
  // final Map boutique;
  final User user;
  final String userid;
  const DetailsBoutique({super.key, required this.userid, required this.user});

  @override
  State<DetailsBoutique> createState() => _DetailsBoutiqueState();
}

class _DetailsBoutiqueState extends State<DetailsBoutique> {
  List<ArticleModel> articles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: FutureBuilder(
            future: ProductService.getSingleArticle(userId: widget.userid)
                .then((value) {
              print("status code ${value.statusCode}");
              if (value.statusCode.toString() == '200') {
                // Clear the list before adding new items to prevent duplicates on hot reload
                // or if FutureBuilder rebuilds for some reason.
                articles.clear();
                for (var item in jsonDecode(value.body) as List) {
                  try {
                    articles.add(ArticleModel.fromJson(item)!);
                  } catch (e) {
                    print(e);
                  }
                }
              }
            }),
            builder: (contex, snapshot) {
              if (snapshot.hasError) {
                return const Text("Une erreur est survenue");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WaitWidget();
              }
              return pageContainer();
            })

        //  pageContainer(),
        );
  }

  Container pageContainer() {
    return Container(
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    widget.user.userName!.toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2),
                  ),
                  const Text("Mode"),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListArticle(
              articleModel: articles,
            )
          ],
        ),
      ),
    );
  }
}

class ListArticle extends StatelessWidget {
  final List<ArticleModel> articleModel;
  const ListArticle({super.key, required this.articleModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      width: double.maxFinite,
      child: articleModel.isNotEmpty
          ? GridView.builder(
              // <-- Modifié ici
              physics: const NeverScrollableScrollPhysics(),
              // padding: const EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 articles par ligne
                crossAxisSpacing: 0.0, // Pas d'espace horizontal
                mainAxisSpacing: 0.0, // Pas d'espace vertical
                childAspectRatio:
                    0.7, // Ajustez ce rapport pour que les articles s'adaptent bien
              ),
              itemCount: articleModel.length,
              itemBuilder: (context, index) =>
                  ItemPublicationWidget(item: articleModel[index]),
            )
          : const AucunElement(
              label: "Aucun article",
            ),
    );
  }
}

class ItemPublicationWidget extends StatelessWidget {
  const ItemPublicationWidget({
    super.key,
    required this.item,
  });

  final ArticleModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailArticle(
                      article: item,
                    )));
      },
      child: Container(
        // width: ScreenSize.width * 0.48, // <-- Supprimé ici, GridView gère la largeur
        height: 268,
        // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1), // <-- Peut être ajusté si des marges minimales sont souhaitées
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1), color: Colors.black),
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: item.thumbnails == null || false
                      ? Image.asset("assets/medias/articles/article2.jpg",
                          fit: BoxFit.fitHeight)
                      : Image.network(
                          item.thumbnails!.url!,
                          fit: BoxFit
                              .cover, // Utilisez BoxFit.cover pour remplir l'espace
                        )),
            )),
            Positioned(
                bottom: 5,
                left: 0, // <-- Ajouté pour aligner à gauche
                right:
                    0, // <-- Ajouté pour s'étirer sur toute la largeur de l'élément de la grille
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8), // Garder une petite marge intérieure
                  // height: 70, // <-- Peut être supprimé ou ajusté si nécessaire
                  padding: const EdgeInsets.only(
                      left: 12,
                      top: 4,
                      bottom:
                          4), // Ajouté padding vertical pour un meilleur rendu
                  // width: ScreenSize.width * 0.4, // <-- Supprimé ici
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withAlpha(222)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        NumberFormat.currency(
                                locale: 'fr',
                                symbol: item.currency,
                                decimalDigits: 0)
                            .format(item.price),
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Text(item.name!,
                          style: GoogleFonts.roboto(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                      Text(
                          "${item.buys} achats effectués / Reste: ${item.qte} en Stock",
                          style: GoogleFonts.roboto(
                              fontSize: 11, color: couleurPrincipale))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class AucunElement extends StatelessWidget {
  final String label;
  const AucunElement({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: couleurPrincipale.withAlpha(80)),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/illustration/empty.svg",
            width: 300,
            fit: BoxFit.cover,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                label,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
  }
}
