import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/upLoadFile.dart';
import 'package:http/http.dart'as http; 

class Register{

  static String server=apiLink+'/auths/register'; 


  static Future createUser({
    required User user, 
    File? picture
  })async{
    String result='';

    Map userData=user.toJson2();

    if(picture!=null){
      dynamic value=await UploadFile.saveFile(picture!);

      if(UploadFile.obtainTrushUrl(value)){
        userData['files']=UploadFile.getTrushPath(value);
      }
    }

    
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