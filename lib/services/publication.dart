import 'dart:convert';
import 'dart:io';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/prod.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class PublicationService{

  static Future  uloadFile(File file)async{
    // String fileName=file.
    final url= Uri.parse("$apiLink/uploads");
    print('avant catch');
    try{
      final mimeType=lookupMimeType(file.path)??'application/octet-stream';
      final mimeTypeData=mimeType.split('/');

      var request=http.MultipartRequest('POST', url);
      request.files.add(
        http.MultipartFile.fromBytes('files', await file.readAsBytes() )
      );

      var response=await request.send();
      print("status code ${response.statusCode}");
      
      var responseData= await http.Response.fromStream(response);
      var responseBody=json.decode(responseData.body);
      print(" body: $responseBody");
        
    }
    catch(e){ 
      print(" test: $e ");
    }
    //  print('Apres catch');
  }


  static obtainUrl(dynamic data){
    return data[0]['url'];
  }



  // faire une publication
  static Future<String> uploadFileOnserver({
    required File file,
    required String description,
    String? type, 
    String? articleName
  })async{
    // String url="$apiLink/uploads";
    // String result='';
    // Dio dio=Dio();
    String url="$apiLink/publications";
    String result='';
    await saveFile(file).then((value)async{

      
        Map data={
            'user':DataController.user!.id, 
            'content':description,
            if(type!=null)
            'type':type,
            if(articleName!=null)
            'alerteName':articleName,
            'files':[
              {
                'url':value
              }
            ]
      };
      print("Valeur upload: $value ");
      if(obtainTrushUrl(value)){

        Map data={
            'user':DataController.user!.id, 
            'content':description,
            if(type!=null)
            'type':type,
            if(articleName!=null)
            'alerteName':articleName,
            'files':getTrushPath(value)
        };

        await http.post(Uri.parse(url),body: jsonEncode(data),headers:{'Content-Type':'application/json'}).then((value){
          print("status code publication: ${value.statusCode}");
          if(value.statusCode.toString()=='200'){
            result='OK';
          }
          else{
            result='ERROR';
          }
        }).catchError((e){
          result='ERROR';
        });

      }
      else{
        result="ERROR";
        return null;
      }
      
    });

    return result;
    
  }

  static Future<http.Response?> addVente(File file,Map data)async{
    http.Response? response;
    await saveFile(file).then((value)async {
      if(obtainTrushUrl(value)){
        data['files']=getTrushPath(value);
        print(data);
        await http.post(Uri.parse('$apiLink/publications'),headers:{'Content-type':'application/json'},body: jsonEncode(data)).then((value){
          print("Publication article status ${value.statusCode}");
          // return value;
          response=value;
        }).catchError((e){
          print("ERROR $e");
          return e;
        });
      }
    }).catchError((e){
      return e;
    });
    return response;
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

  // la liste des publications

  static Future<http.Response> getPublications({
    String? type, 
    String? userId 
  })async{
    // String url="$apiLink/publications";
    final Uri url=Uri.parse("$apiLink/publications").replace(queryParameters: {
      if(type!=null)
      'type':type, 
      if(userId!=null)
      'user':userId,
    });
    return await http.get(url).then((value){
      return value;
    }).catchError((e){
      print("publication errorrrrr $e");
      return e;
    });
  }

  static Future suppression(String id)async{
    String url="$apiLink/publications/$id";
    return await http.delete(Uri.parse(url)).then((value){
      return value.statusCode;
    }).catchError((e){
      print(e);
      return e;
    });
  }

  static Future<http.Response?> getNumberLike(String id,String type)async{
    return await http.get(Uri.parse("$apiLink/publication-managements").replace(queryParameters: {
      'type':'like',
      'publication':id
    })).then((value) {
      if(value.statusCode.toString()=='200'){
        return value;
      }
    }).catchError((e){
      print(e);
      return e;
    });
  }

  static Future<http.Response> addLike(Map data)async{
    return await http.post(Uri.parse("$apiLink/publication-managements"),headers:{'Content-Type':'Application/json'},body:jsonEncode(data)).then((value){
      return value;
    }).catchError((e){  
      print("ERRORR $e");
      return e;
    });
  }

  static Future<http.Response> deleteLike(String id)async{
    return await http.delete(Uri.parse("$apiLink/publication-managements/$id")).then((value) {
      return value;
    }).catchError((e){
      print("ERROR $e");
      return e;
    });
  }

}