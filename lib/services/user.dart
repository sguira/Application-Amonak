import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class UserService{

  static String server=apiLink+'/users';

  

  
  
  


  static Future<http.Response> getAllUser()async{
    // List<User> users=[];
    print("token value $tokenValue");
    return await http.get(Uri.parse(server),headers: authHeader ).then((value){
      return value;
    });

    
  }

  static Future<http.Response> getUser({
    required String userId
  })async{
    return await http.get(Uri.parse("$apiLink/users/$userId"),headers: authHeader).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> searchUser(String query)async{
    return await http.get(Uri.parse(server).replace(queryParameters: {'search':query}),headers: authHeader).then((value){
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future sendFriend(String id)async{
    String resutl='';
    Map data={
      'to':id, 
      'from':DataController.user!.id
    };
    print(" id: $id");
    print("to ${DataController.user!.id}");
    await http.post(Uri.parse(apiLink+'/friends/send'),body: jsonEncode(data), headers: {"content-type":"application/json"} ).then((value){
      print(value.statusCode);
      if(value.statusCode.toString()=='200'){
        resutl='OK';
      }
      else{
        resutl='ERROR';
      }
    });

    return resutl;
  }

  static Future<http.Response> getBoutique({
    String? search
  })async{
    Uri uri=Uri.parse("$apiLink/users").replace(queryParameters: {
      'accountType':'seller', 
      if(search!=null)
      'search':search
    });
    return await http.get(uri,headers:authHeader).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

}