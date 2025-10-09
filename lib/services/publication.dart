import 'dart:convert';
import 'dart:io';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/ThumbnailsService.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PublicationService {
  // static PublicationSocket socket=PublicationSocket();

  static obtainUrl(dynamic data) {
    return data[0]['url'];
  }

  // faire une publication
  static Future<Map<String, dynamic>> uploadFileOnserver(
      {required File file,
      required String description,
      String? type,
      String? articleName}) async {
    // String url="$apiLink/uploads";
    // String result='';
    // Dio dio=Dio();
    String url = "$apiLink/publications";
    Map<String, dynamic> result = {"code": "ERROR"};
    await saveFile(file).then((value) async {
      Map data = {
        'user': DataController.user!.id,
        'content': description,
        if (type != null) 'type': type,
        if (articleName != null) 'alerteName': articleName,
        'files': [
          {'url': value}
        ]
      };
      print("Valeur upload: $value ");
      if (obtainTrushUrl(value)) {
        Map data = {
          'user': DataController.user!.id,
          'content': description,
          if (type != null) 'type': type,
          if (articleName != null) 'alerteName': articleName,
          'files': getTrushPath(value)
        };

        await http.post(Uri.parse(url),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'}).then((value) {
          print("status code publication: ${value.statusCode}");
          if (value.statusCode.toString() == '200') {
            result["code"] = "OK";
            result["data"] = jsonDecode(value.body);
          } else {
            result["code"] = "ERROR";
          }
        }).catchError((e) {
          result["code"] = "ERROR";
        });
      } else {
        result["code"] = "ERROR";
        return null;
      }
    });

    return result;
  }

  static Future<http.Response> getPublicationById({required String id}) async {
    return await http.get(Uri.parse("$apiLink/publications/$id")).then((value) {
      print("status code publication: ${value.statusCode}");
      return value;
    }).catchError((e) {
      return e;
    });
  }

  static Future<http.Response> sharePublication(
      {required Map<String, dynamic> data}) async {
    // Map data={
    //         'user':DataController.user!.id,
    //         'content':pub.content,
    //         'type':'share',
    //         'files':getTrushPath(value)
    // };

    return await http
        .post(Uri.parse("$apiLink/publications"),
            headers: authHeader, body: jsonEncode(data))
        .then((value) {
      return value;
    }).catchError((e) {
      print(e);
      return e;
    });
  }

  static Future<http.Response?> addVente(File file, Map data) async {
    http.Response? response;
    var thmbnailsResponse = null;
    var valueThumb = null;
    final thumb = await GenerateThumbnailsService.generate(file: file);

    if (thumb != null) {
      valueThumb = await saveFile(thumb);
      thmbnailsResponse = getTrushPath(valueThumb);
    }
    await saveFile(file).then((value) async {
      if (obtainTrushUrl(value)) {
        if (obtainTrushUrl(valueThumb)) {
          print("WOLLLLAYYYYYYYYY Thumbnails envoyé \n\n\n\n");
          data['files'] = [...getTrushPath(value), ...thmbnailsResponse];
        } else {
          data['files'] = [...getTrushPath(value)];
        }
        print(
            "Mes donnée envoyée ${data}\n\n\n\n Taille des fichiers ${data.length}");
        await http
            .post(Uri.parse('$apiLink/publications'),
                headers: {'Content-type': 'application/json'},
                body: jsonEncode(data))
            .then((value) {
          print("Publication article status ${value.statusCode}");
          // if(value.statusCode==200){
          //   socket.emitCreation(event: 'newPublicationListener', data: jsonDecode(value.body));
          // }
          // return value;
          response = value;
        }).catchError((e) {
          print("ERROR $e");
          return e;
        });
      }
    }).catchError((e) {
      return e;
    });
    return response;
  }

  static bool obtainTrushUrl(List<Map> urls) {
    for (var item in urls) {
      if (item['url'] != 'ERROR') {
        return true;
      }
    }
    return false;
  }

  static getTrushPath(List<Map> urls) {
    List<Map> output = [];
    for (var item in urls) {
      if (item['url'] != 'ERROR') {
        output.add(item);
      }
    }
    return output;
  }

  static Future<List<Map>> saveFile(File file) async {
    String url = "$apiLink/uploads";
    List<Map> result = [];
    Dio dio = Dio();

    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      FormData formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(file.path,
            filename: basename(file.path),
            contentType: MediaType.parse(mimeType))
      });

      await dio
          .post(url,
              data: formData,
              options:
                  Options(headers: {'Content-type': 'multipart/form-data'}))
          .then((value) {
        print("Status code: ${value.statusCode}");
        print("Vidéo envoyé ${value.data}");
        if (value.statusCode.toString() == '200') {
          for (var item in value.data as List) {
            print("type de la publication ${item['type']}\n\n ");
            result.add(item);
          }
        } else {
          result.add({'url': 'ERROR'});
        }
      }).catchError((e) {
        print(e);
        result.add({'url': 'ERROR'});
      });
    } catch (e) {
      result.add({'url': 'ERROR'});
    }
    return result;
  }

  // la liste des publications

  static Future<http.Response> getPublications(
      {String? type, String? userId, String? search, int? limite}) async {
    // String url="$apiLink/publications";
    final Uri url =
        Uri.parse("$apiLink/publications").replace(queryParameters: {
      if (type != null) 'type': type,
      if (userId != null) 'user': userId,
      if (search != null) 'search': search,
      'statut': true.toString(),
      if (limite != null) 'limit': "${limite}",
    });
    return await http.get(url).then((value) {
      return value;
    }).catchError((e) {
      print("publication errorrrrr $e");
      return e;
    });
  }

  static Future suppression(String id) async {
    String url = "$apiLink/publications/$id";
    return await http.delete(Uri.parse(url)).then((value) {
      return value.statusCode;
    }).catchError((e) {
      print(e);
      return e;
    });
  }

  static Future<http.Response?> getNumberLike(String id, String type) async {
    return await http
        .get(Uri.parse("$apiLink/publication-managements")
            .replace(queryParameters: {'type': 'like', 'publication': id}))
        .then((value) {
      if (value.statusCode.toString() == '200') {
        return value;
      }
    }).catchError((e) {
      print(e);
      return e;
    });
  }

  static Future<http.Response> addLike(Map data) async {
    return await http
        .post(Uri.parse("$apiLink/publication-managements"),
            headers: {'Content-Type': 'Application/json'},
            body: jsonEncode(data))
        .then((value) {
      return value;
    }).catchError((e) {
      print("ERRORR $e");
      return e;
    });
  }

  static Future<http.Response> deleteLike(String id) async {
    return await http
        .delete(Uri.parse("$apiLink/publication-managements/$id"))
        .then((value) {
      return value;
    }).catchError((e) {
      print("ERROR $e");
      return e;
    });
  }
}
