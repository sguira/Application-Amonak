import 'package:application_amonak/models/user.dart';
class NotificationModel{
  late String? id;
  late String? content;
  late User? from;
  late String? type;
  late DateTime? createAt;
  late String? like;
  late String? title;
  late String action;
  late String spec;
  late dynamic data;
  String? idPub;
  static NotificationModel fromJson(dynamic data){


    // print("\n\n notif ${data}");

    NotificationModel notificationModel=NotificationModel();
    notificationModel.id=data['_id'];
    notificationModel.createAt=DateTime.parse(data['createdAt']);
    print("data content ${data['content']}");
    if (data['content'] == "comment.commentAPublication") {
      notificationModel.content = 'a commenté votre publication';
      notificationModel.action="details_publication";
      notificationModel.idPub=data['publication'];
    } else if (data['content'] == 'comment.likeYourComment') {
      notificationModel.content = 'a aimé votre commentaire';
    } else if (data['content'] == 'comment.likeAPublicationcomment') {
      notificationModel.content = 'a aimé votre publication';
    } else if (data['content'] == "friendRequest.accept") {
      notificationModel.content = "a accepté votre invitation";
    } else if (data['content'] == "friendRequest.reject") {
      notificationModel.content = "a réjété votre invitation ";
    } else if (data['content'] == "friendRequest.send") {
      notificationModel.content = "Vous a ajouté à ses amis";
    } else if (data['content'] == "publicationBackend.likeYourPublication") {
      notificationModel.content = "a aimé votre publication";
    } else if(data['content']=="publicationBackend.likeYourPublication"){
      notificationModel.idPub=data['publication'];
      notificationModel.content = 'a commenté votre publication';
      notificationModel.action="details_publication";
    }
    else if(data['type']=="share"){
      notificationModel.content="a partagé votre publicaation";
      notificationModel.action="share";
      notificationModel.idPub=data['publication'];
    }
    
    
    notificationModel.type=data['type'];
    // notificationModel.createAt=DateFormat("yyyyy-MM-dd HH:mm").format(data['createdAt']);
    notificationModel.from=User.fromJson(data['from']);
    notificationModel.title=data['type']=='like'?"Like":"Commentaire";

    
    if(data['content']=='friendRequest.send')
    {
      notificationModel.action="users";
      notificationModel.data=User.fromJson(data['from']);
    }
    if(data['content']=='comment.commentYourPublication'){
      notificationModel.action="details_publication";
      notificationModel.idPub=data['publication'];
    }
    if(data['content']=='publicationBackend.likeYourPublication'){
      notificationModel.action="details_publication";
      notificationModel.idPub=data['publication'];
    }

    return notificationModel;
  }
}