import 'dart:io';
import 'package:application_amonak/prod.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class UploadFile{


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
            // print("type de la publication ${item['type']}\n\n ");
            result.add(item);
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

  static bool obtainTrushUrl(List<Map> urls){
    for(var item in urls){
      if(item['url']!='ERROR'){
        return true;
      }
    }
    return false;
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

  static removeFile(String id)async{
    await http.delete(Uri.parse("$apiLink/uploads/$id")).then((value) {

    }).catchError((e){

    });
  }

}