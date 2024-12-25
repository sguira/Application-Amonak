import 'dart:convert';

import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:http/http.dart'as http; 

class Register{

  static String server=apiLink+'/auths/register'; 


  static Future createUser(User user)async{
    String result='';
    
    await http.post(Uri.parse(server),
    body: jsonEncode(user.toJson2()),
    headers: {"content-type":"application/json"}
    ).then((value){
      print("value   ${value.body}\n\n n");
      print("statusCode ${value.statusCode} \n\n\n ");
      if(value.statusCode.toString()=='201'){
        result='OK';
      }
      else{
        result="ERROR";
      }
    }).catchError((e){
      print("Errorrrr $e");
      print(e);
      result="ERROR";
    });
    return result;
  }

}