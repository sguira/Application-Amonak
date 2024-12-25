

import 'dart:convert';

import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;
class CommentaireService{
  static String url="$apiLink/comments";

  static Future<http.Response> saveComent(Commentaire com)async{
    return await http.post(Uri.parse(url),headers:{'Content-type':'application/json'},body:jsonEncode(com.toJson())).then((value){
      return value;
    }).catchError((e){
      print("ERROR $e\n\n");
      return e;
    });
  }

  static Future<http.Response> getCommentByPublication(String pubId)async{
    final Uri uri=Uri.parse("$apiLink/comments").replace(
      queryParameters: {
        'publication':pubId
      }
    );
    return await http.get(uri).then((value) {
      return value;
    }).catchError((e){
      print(e);
      return e;
    });
  }
}