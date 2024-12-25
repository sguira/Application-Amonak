import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:http/http.dart' as http;
class SellerService{

  static String url="$apiLink/seller-requests/${DataController.user!.id}";

  static Future addSeller(Map data,File file)async{
    String result='ERROR';
    print("URL $url");
    await PublicationService.saveFile(file).then((value)async{
      if(value!='ERROR'){
        data['files']=[
          value
        ];
        await  http.patch(Uri.parse(url),headers:{"Content-type":"application/json"},body:jsonEncode(data)).then((value){
          print("Status Seller ${value.statusCode}");
          if(value.statusCode=='200'){
            result='OK';
          }
          else{
            result='ERROR';
          }
        });
      }
      else{
        result='ERROR';
        return;
      }
    }).catchError((e){
      result='ERROR';
      print("ERROR $e\n\n");
    });
    return result;
  }
}