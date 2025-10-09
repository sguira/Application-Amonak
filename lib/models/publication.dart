import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/file.dart';
import 'package:application_amonak/models/user.dart';

class Publication {
  String? id;
  String? content;
  String? userId;
  String? userName;
  List<Files> files = [];
  String? type;
  String? typePub;
  String? share;
  String? shareMessage;
  double? price;
  Files? thumbnails;
  double frais = 1000;
  DateTime? dateCreation;
  // double
  int qte = 0;
  List<Commentaire> commentaires = [];
  User? user;

  //une publication de type partage
  User? userShare;
  DateTime? shareDate;

  // ArticleModel? article;
  String? productId;

  static Publication fromJson(Map data) {
    Publication publication = Publication();
    // print("dataa $data ");
    try {
      publication.id = data['_id'] ?? '';
      publication.content = data['content'] ?? '';
      publication.userId = data['user']["_id"];
      publication.userName = data['user']['userName'] ?? '';
      publication.user = User.fromJson(data['user']);
      publication.typePub = data['type'] ?? '';
      publication.dateCreation = DateTime.parse(data['createdAt']);
      if (publication.typePub == 'sale') {
        // publication.article=ArticleModel(name: data['name']??'', price: double.parse(data['price']), qte: int.parse(data['quantity']));
        publication.productId = data['product'];
      }
      for (var item in data['files'] as List) {
        Files file = Files();
        // file.url=item['url']??'';
        file.sId = item['_id'] ?? '';
        file.url = item['url'] ?? '';
        file.type = item['type'] != null && item['type'] != 'application'
            ? item['type']
            : item['url'].toString().contains('mp4')
                ? 'video'
                : 'image';
        publication.files.add(file);
      }
      // if (publication.files.length > 1) {
      //   publication.thumbnails = publication.files[-1];
      //   print("Thumbnails chargé !!!!!\n\n\n");
      // }
      publication.type = publication.files[0].type;

      // publication.type=data['type']?data['type']: file.url!.contains("mp4")?'video':'image';
      // publication.files=file;
      print("Bien chargé  ");
    } catch (e) {
      print("error publication: $e\n\n");
    }

    return publication;
  }
}
