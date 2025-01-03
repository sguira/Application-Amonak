
import 'package:application_amonak/models/like.dart';
import 'package:application_amonak/models/user.dart';
import 'package:intl/intl.dart';
class Commentaire{
  String? content;
  String? date; 
  String? id;
  String? userId;
  String? publicationId;
  User? user; 
  String? avatar; 
  bool isLike=false;
  int? nbLikes=0;
  List<Like>? likes=[];
  // String? createdAt; 
  toJson(){
    return {
      'user':userId, 
      'publication':publicationId,
      'content':content
    };
  } 

  static Commentaire fromJson(Map data){
    Commentaire commentaire=Commentaire();
    commentaire.content=data['content']; 
    commentaire.id=data['_id'];
    commentaire.user=User.fromJson(data['user']);
    commentaire.nbLikes=(data['likes'] as List).length;
    // commentaire.createdAt=DateFormat("yyyy-Mm-dd HH:mm").format(data['createdAt']);
    if((data['likes'] as List).isNotEmpty){
      for(int i=0;i<data['likes'].length;i++){
        Like like=Like();
        like.userId=data['likes'][i]['user'];
        like.commentId=data['likes'][i]['comment'];
        like.id=data['likes'][i]['_id'];
        commentaire.likes!.add(like);
      }
    }
    return commentaire;
  }


}