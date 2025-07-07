import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/upLoadFile.dart';
import 'package:http/http.dart' as http;
class MessageService{

  static const String url="$apiLink/messages";

  static Future<http.Response> sendMessage({
    required MessageModel message, 
    File? file
  })async{
    // String result='';
    Map data=message.toJson();
    if(file!=null){
      dynamic value= await UploadFile.saveFile(file);
      if(UploadFile.obtainTrushUrl(value)){
          // message.files=MessageModel.loadFile(UploadFile.getTrushPath(value));
          data['files']=UploadFile.getTrushPath(value);
      }
    }
    return await http.post(Uri.parse(url),headers: {'Content-Type':'application/json'},body: jsonEncode(data)).then((value) {
      print("Status code :${value.statusCode}");
      
      return value;
    }).catchError((e){
      print(e);
      return e;
    });
   
  }

  static Future<http.Response> getMessage ({
   Map<String,dynamic>? params
  })async{
    
    Uri uri=Uri.parse(url).replace(queryParameters: params!);
    return await http.get(uri).then((value) {
      // print("value ${value.body}");
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<List> allMessageSendOrReceiveByUser(String id)async{
    List res=[];
    Uri uriSend=Uri.parse("$apiLink/messages").replace(queryParameters: {'from':id});
    Uri uriReceive=Uri.parse("$apiLink/messages").replace(queryParameters: {'to':id});
    return await http.get(uriSend).then((value) async{
      if(value.statusCode==200){
        // res=jsonDecode(value.body);
        
        res.addAll(jsonDecode(value.body)as List);
        await http.get(uriReceive).then((value) {
          res.addAll(jsonDecode(value.body)as List);
          }).catchError((e){
            print("print jonction $e");
            
            return res;
          });
          
          
      }
      // else{res="ERROR";}
      return res;
    }).catchError((e){
      // res['code']="ERROR";
      print("ERROR grand $e");
      return res;
    });
    
    
  }

  static Future<http.Response> getAllMessage()async{
    return await http.get(Uri.parse("$apiLink/messages"),headers: authHeader).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> modifierMessage(
    {
      required String messageId, 
      required Map<String,dynamic> data
    }
  )async{
    return await http.patch(Uri.parse("$apiLink/messages/$messageId"),headers: authHeader,body: jsonEncode(data)).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> deleteMessage({
    required String id
  })async{
    return await http.delete(Uri.parse("$apiLink/messages/$id"),headers: authHeader).then((value){
      return value;
    }).catchError((e){
      return e;
    });
  }

}