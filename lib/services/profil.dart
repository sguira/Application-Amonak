import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/file.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
class ProfilService{

  static String url="$apiLink/users/${DataController.user!.id}";
  
  static Future upadteProfil(Map data)async{
    // user.password=null;
    String result='';
    // print("body ${user.toJson()}");
    await http.put(Uri.parse(url),headers:authHeader,body: jsonEncode(data)).then((value){
      print(value.statusCode);
      if(value.statusCode==200){
        // DataController.user=user;
        DataController.user!.description=data['description'];
        DataController.user!.userName=data['userName'];
        DataController.user!.email=data['email'];
        result='OK';
      }
      else{
        result='ERROR';
      }
    }).catchError((e){
      print("ERROR $e");
      result='ERROR';
    });
    return result;
  }


  static Future<List<Map>> saveFile(File file)async{

    String url="$apiLink/uploads";
    List<Map> result=[];
    Dio dio=Dio();

    try{
      final mimeType=lookupMimeType(file.path)??'application/octet-stream';
      FormData formData=FormData.fromMap({
        'files':await MultipartFile.fromFile(
          file.path, 
          filename: basename(file.path), 
          contentType: MediaType.parse(mimeType)
        )
      });

      await dio.post(url,data: formData,options: Options(
        headers:{
          'Content-type':'multipart/form-data'
        }
      )).then((value){
        print( "Status code: ${value.statusCode}");
        // print(value.data);
        if(value.statusCode.toString()=='200'){
          for(var item in value.data as List){
            print("type de la publication ${item['type']}\n\n ");
            result.add({
              'url':item['url'], 
              'type':item['type'], 
              'extension':item['extension'], 
              'originalname':item['originalname'], 
              'filename':item['filename'],
              'size':item['size'], 

            });
          }
        }
        else{
          result.add({
            'url':'ERROR'
          });
        }
      }).catchError((e){
        print(e);
        result.add({
            'url':'ERROR'
        });
      });
    }
    catch(e){
      result.add({
            'url':'ERROR'
      });
    }
    return result;
  }

  static getTrushPath(List<Map> urls){
    List<Map> output=[];
    for(var item in urls){
      if(item['url']!='ERROR'){
        output.add(item);
      }
    }
    return output;
  }

  static bool obtainTrushUrl(List<Map> urls){
    for(var item in urls){
      if(item['url']!='ERROR'){
        return true;
      }
    }
    return false;
  }

  static Future<String> updatePictureProfile(File file)async{
    String res="";
    List<Files> files=[];
    await saveFile(file).then((value)async{
      // print(value);
      if(obtainTrushUrl(value)){
        
        List f=getTrushPath(value);
        for(var item in f){
          files.add(Files.fromJson(item));
        }
        await http.put(Uri.parse("$apiLink/users/${DataController.user!.id}"),headers:authHeader,body: jsonEncode({
        'avatar':files
        })).then((value) {
          if(value.statusCode==200){
            res="OK";
            DataController.user!.avatar=files;
          }
          else{
            res="ERROR";
          }
        }).catchError((e){
          print("error $e");
          res="ERROR";
        });
      }
      else{
        print("ERROR");
      }
      
    }).catchError((e){
      print("error $e");
      res="ERROR";
    });
    return res;
  }
}