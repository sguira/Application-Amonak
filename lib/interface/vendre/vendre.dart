import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/vendre/WidgetVenteContainer.dart';
import 'package:application_amonak/interface/vendre/congrat.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class VendrePage extends StatefulWidget {
  final String? articleId;
  final ArticleModel? article;
  const VendrePage({super.key,this.articleId,this.article});

  @override
  State<VendrePage> createState() => _VendrePageState();
}

class _VendrePageState extends State<VendrePage> {

  int currentIndex=1;

    ArticleModel? articleModel;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.article!=null){
      articleModel=widget.article;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body:widget.article==null && widget.articleId!=null ? FutureBuilder(
        future: ProductService.getSingleArticle(id: widget.articleId).then((value){
          print("statussss code ${value.statusCode}");
          if(value.statusCode.toString()=='200'){
            // print(value.body);
            articleModel=ArticleModel.fromJson(jsonDecode(value.body));
          }
        }),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const WaitWidget();
          }
          if(snapshot.hasError){
            return Container(
              alignment: Alignment.center,
              child:const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Une erreur est survenue")
                ],
              ),
            );
          }
          return VenteContenu(articleModel: articleModel,);
        }
      ):VenteContenu(articleModel: articleModel),
    );
  }

 
}