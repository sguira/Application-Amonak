class Like{
  String? id;
  String? userId;
  String? commentId; 


  static Like fromJson(Map data){
    Like like=Like();
    like.id=data['id'];
    like.userId=data['user']; 
    like.commentId=data['commentId'];

    return like;
  }
}