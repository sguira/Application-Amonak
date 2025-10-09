import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/vendre/WidgetVenteContainer.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendrePage extends StatefulWidget {
  final String? articleId;
  final ArticleModel? article;
  const VendrePage({super.key, this.articleId, this.article});

  @override
  State<VendrePage> createState() => _VendrePageState();
}

class _VendrePageState extends State<VendrePage> {
  int currentIndex = 1;

  ArticleModel? articleModel;
  bool notFound = true;
  loadData() async {
    print("Mon id produit: ${widget.articleId}");
    await ProductService.getSingleArticle(id: widget.articleId, userId: null)
        .then((value) {
      print("statussss code ${value.statusCode}");
      if (value.statusCode == 200) {
        // print(value.body);
        setState(() {
          articleModel = ArticleModel.fromJson(jsonDecode(value.body));
          notFound = false;
        });
      }
    });
  }

  Future<void>? initLoad;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.article != null) {
      articleModel = widget.article;
    }
    initLoad = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(),
      body: widget.article == null && widget.articleId != null
          ? FutureBuilder(
              future: initLoad,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WaitWidget();
                }
                if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Une erreur est survenue")],
                    ),
                  );
                }
                return notFound == false
                    ? VenteContenu(
                        articleModel: articleModel,
                      )
                    : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "L'article a été supprimé ",
                              style: GoogleFonts.roboto(
                                  color: couleurPrincipale,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.2),
                            ),
                            Image.asset("assets/illustration/delete.gif"),
                          ],
                        ),
                      );
              })
          : VenteContenu(articleModel: articleModel),
    );
  }
}
