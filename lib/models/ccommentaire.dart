
import 'package:application_amonak/models/like.dart';
import 'package:application_amonak/models/user.dart';
class Commentaire{
  String? content;
  DateTime? date; 
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
    try{
      commentaire.nbLikes=(data['likes'] as List).length;
      if((data['likes'] as List).isNotEmpty){
      for(int i=0;i<data['likes'].length;i++){
        Like like=Like();
        like.userId=data['likes'][i]['user'];
        like.commentId=data['likes'][i]['comment'];
        like.id=data['likes'][i]['_id'];
        commentaire.likes!.add(like);
      }
    }
    }
    catch(e){
      print(e.toString());
      commentaire.nbLikes=0;
    }
    try{
      commentaire.date=DateTime.parse(data['createdAt']);
    }
    catch(e){
      commentaire.date=DateTime.now();
    }
    // commentaire.createdAt=DateFormat("yyyy-Mm-dd HH:mm").format(data['createdAt']);
    
    return commentaire;
  }


}