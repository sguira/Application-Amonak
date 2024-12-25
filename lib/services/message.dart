import 'dart:convert';

import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;
class MessageService{

  static final String url="$apiLink/messages";

  static Future sendMessage(MessageModel message)async{
    String result='';
    await http.post(Uri.parse(url),headers: {'Content-Type':'application/json'},body: jsonEncode(message.toJson())).then((value) {
      print("Status code :${value.statusCode}");
      if(value.statusCode.toString()=='200'){
        
        result='OK';
      }
      else{
        result='ERROR';
      }
    }).catchError((e){
      print(e);
      result='ERROR';
    });
    return result;
  }

  static Future<http.Response> getMessage ({
    required String from,
    required String? to
  })async{
    
    Uri uri=Uri.parse(url).replace(queryParameters: {
      'from':from, 
      'to':to
    });
    return await http.get(uri).then((value) {
      return value;
      print(value.body);
    }).catchError((e){
      return e;
    });
  }

}