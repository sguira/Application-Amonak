import 'package:application_amonak/prod.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<http.Response> getSingleArticle(
      {String? userId, String? id}) async {
    String link = id != null ? '$apiLink/products/$id' : '$apiLink/products';
    Uri uri = userId == null
        ? Uri.parse(link)
        : Uri.parse(link).replace(queryParameters: {'user': userId});
    print("url ${link}");
    return await http.get(uri).then((value) {
      // print("value ${value.statusCode}");
      return value;
    }).catchError((e) {
      print(e);
      return e;
    });
  }
}
