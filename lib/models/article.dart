

import 'dart:io';
import 'dart:typed_data';

import 'package:application_amonak/models/file.dart';
import 'package:application_amonak/models/user.dart';
// import 'package:get_thumbnail_video/index.dart';
// import 'package:get_thumbnail_video/video_thumbnail.dart';
// import 'package:video_compress/video_compress.dart';

class ArticleModel{
  String? id;
  String? content;  
  String? name;
  List<Files> files=[];
  int? qte;
  double? price;
  double? frais=0;
  double? livraison=7;
  String? currency;
  User? user;
  bool? status;
  int? buys;
  String? creatAt;
  double? total;
  Uint8List? thumbail;
  ArticleModel({
    required this.name, 
    required this.price, 
    required this.qte, 
    // this.frais,
    // this.livraison
  }){
    total=livraison!+frais!+price!;
  }

  static ArticleModel? fromJson(Map data){
    try{
     ArticleModel articleModel=ArticleModel(name: data['name']??'', price:double.parse(data['price'].toString()), qte: data['quantity']);

      articleModel.id=data['_id'];
      articleModel.buys=data['buys'];
      articleModel.user=User.fromJson(data['user']);
      for(var item in data['files'] as List){
        articleModel.files.add(Files.fromJson(item));
      }
      articleModel.content=data['content'];
      articleModel.status=data['status']; 
      articleModel.currency=data['currency'];
      if(articleModel.files.isNotEmpty && Platform.isWindows==false ){
        // getThumbailLink(articleModel.files.first.url!).then((value) {
        //   articleModel.thumbail=value;
        // }).catchError((e){
        //   print("ERROR thumb $e");
        // });
      }
      return articleModel;
    }
    catch(e){
      print("ERRORRRR PRODUCT $e");
      return null;
    }
  }

  // static Future<Uint8List?> getThumbailLink(String url)async{
  //   final thumbailsUrl=await VideoCompress.getByteThumbnail(
  //    url, 
  //    quality: 75, 
  //    position: -1
  //   );

  //   return thumbailsUrl;
  // }
}