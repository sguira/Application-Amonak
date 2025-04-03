

import 'dart:convert';

import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/socket/commentSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:http/http.dart' as http;
class CommentaireService{
  static String url="$apiLink/comments";

  // static Commentsocket socket=Commentsocket();

  static Future<http.Response> saveComent(Commentaire com)async{
    return await http.post(Uri.parse(url),headers:{'Content-type':'application/json'},body:jsonEncode(com.toJson())).then((value){
      // socket.emitCreation(event: "commentPublication", data: jsonDecode(value.body));
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

  static Future<http.Response> deleteCommentaire( {
    required String id
  }) async{
    return await http.delete(Uri.parse("$apiLink/comments/$id")).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> updateCommentaire({
    required String id, 
    required String contenu,
  })async{
    return await http.put(Uri.parse("$apiLink/comments/$id"),body:{
      'content':contenu
    }).then((value) {
      return value;
    }).catchError((e){
      print("Une error, $e");
      return e;
    });
  }
}