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
class DetailsBoutique extends StatefulWidget {
  // final Map boutique;
  final User user;
  final String userid;
  const DetailsBoutique({super.key,required this.userid,required this.user});

  @override
  State<DetailsBoutique> createState() => _DetailsBoutiqueState();
}

class _DetailsBoutiqueState extends State<DetailsBoutique> {

  List<ArticleModel> articles=[]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body:FutureBuilder(
        future: ProductService.getSingleArticle(userId: widget.userid).then((value){
          print("status code ${value.statusCode}");
          if(value.statusCode.toString()=='200'){
            for(var item in jsonDecode(value.body) as List){
              try{
                articles.add(ArticleModel.fromJson(item)!);
              }
              catch(e){
                print(e);
              }
            }
          }
        }),
        builder: (contex,snapshot){
          if(snapshot.hasError){
            return Text("Une erreur est survenue");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return WaitWidget();
          }
          return pageContainer();
        }
      )
      
      //  pageContainer(),
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
                  Text(widget.user.userName!.toUpperCase(),style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w600,letterSpacing: 1.2),), 
                  Text("Mode"),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            ListArticle(articleModel: articles,)
          ],
        ),
      ),
    );
  }
}

class ListArticle extends StatelessWidget {
  final List<ArticleModel> articleModel;
  const ListArticle({
    super.key, required this.articleModel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 18),
      width: double.maxFinite,
      child: SingleChildScrollView(
        child:articleModel.isNotEmpty? Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            for(var item in articleModel)
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailArticle(article: item,) ));
              },
              child: Container(
                width: ScreenSize.width*0.45,
                height: 268,
                margin:const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), 
                  color: Colors.black
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:item.thumbail==null? Image.asset("assets/medias/articles/article2.jpg",fit: BoxFit.fitHeight):
                           Image.memory(item.thumbail!)
                          ),
                      )
                    ), 
                    Positioned(
                      bottom: 5,
                      child: Container(
                        margin:const EdgeInsets.symmetric(horizontal: 8),
                        // height: 70,
                        padding:const EdgeInsets.only(left: 12),
                        width: ScreenSize.width*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withAlpha(222) 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(NumberFormat.currency(locale: 'fr',symbol: item.currency,decimalDigits: 0).format(item.price),style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w800),), 
                            Text(item.name!,style:GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w600)), 
                            Text("${item.buys} achats effectués / Reste: ${item.qte} en Stock",style:GoogleFonts.roboto(fontSize: 11,color: couleurPrincipale))
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ):Text("Aucun element"),
      )
    );
  }

  
}