import 'dart:convert';

import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';

class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ListArticleState();
}

class _ListArticleState extends State<Article>
    with AutomaticKeepAliveClientMixin {
  List<ArticleModel> articles = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
          future: ProductService.getSingleArticle().then((value) {
            print("stauscode ${value.statusCode}");
            if (value.statusCode == 200) {
              articles = [];
              for (var item in jsonDecode(value.body) as List) {
                try {
                  articles.add(ArticleModel.fromJson(item)!);
                } catch (e) {
                  print(e);
                }
              }
            }
          }).catchError((e) {
            print("ERRORRRR $e");
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WaitWidget();
            }

            if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Une erreur est survenue")],
                ),
              );
            }
            return page();
          }),
    );
  }

  Widget page() {
    return ListArticle(articleModel: articles);
  }
}
