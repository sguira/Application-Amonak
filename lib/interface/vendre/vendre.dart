import 'dart:convert';

import 'package:application_amonak/interface/vendre/WidgetVenteContainer.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';

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

  loadData() async {
    await ProductService.getSingleArticle(id: widget.articleId).then((value) {
      print("statussss code ${value.statusCode}");
      if (value.statusCode.toString() == '200') {
        // print(value.body);
        setState(() {
          articleModel = ArticleModel.fromJson(jsonDecode(value.body));
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
                return VenteContenu(
                  articleModel: articleModel,
                );
              })
          : VenteContenu(articleModel: articleModel),
    );
  }
}
