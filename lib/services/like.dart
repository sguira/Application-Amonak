import 'dart:convert';

import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;
class LikeService{
  static String url="$apiLink/comment-likes";

  static Future<http.Response> ajouterLike({
    required String commentId, 
    required String userId
  })async{
    return await http.post(Uri.parse(url),headers: {"Content-Type":"application/json"},body: jsonEncode({
      "user":userId, 
      "comment":commentId
    })).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> getNombreLike(String id)async{
    return await http.get(Uri.parse("$apiLink/comment-likes/").replace(queryParameters: {
      "comment":id
     })).then((value){
      // print("Body ${value.body}\n\n\n");
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response>  getLikeByUser({
    required String userId, 
    required String commentId
  }){
    return http.get(Uri.parse("$apiLink/comment-likes").replace(queryParameters: {
      "user":userId,
      "comment":commentId
    })).then((value){
      // print("Body ${value.body}\n\n\n");
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> removeLike(String id)async{
    return await http.delete(Uri.parse("$apiLink/comment-likes/$id")).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

}