import 'package:application_amonak/models/user.dart';
import 'package:intl/intl.dart';
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
  static NotificationModel fromJson(dynamic data){


    print("\n\n notif ${data}");

    NotificationModel notificationModel=NotificationModel();
    notificationModel.id=data['_id'];
    notificationModel.createAt=DateTime.parse(data['createdAt']);
    print("data content ${data['content']}");
    notificationModel.content=data['content']=="comment.commentYourPublication"?
    'a commenté votre publication':data['content']=='comment.likeYourComment'?
    'a aimé votre commentaire':data['content']=='comment.likeAPublicationcomment'?

    'a aimé votre publication':data['content']=="friendRequest.accept"?
    "a accepté votre invitation":data['content']=="friendRequest.reject"?
    "a réjété votre invitation ":data['content']=="friendRequest.send"?
    "Vous ai ajouté à ses amis":data['content']=="publicationBackend.likeYourPublication"?
    "a aimé votre publication":"";
    
    notificationModel.type=data['type'];
    // notificationModel.createAt=DateFormat("yyyyy-MM-dd HH:mm").format(data['createdAt']);
    notificationModel.from=User.fromJson(data['from']);
    notificationModel.title=data['type']=='like'?"Like":"Commentaire";

    if(data['content']=='comment.commentYourPublication'){
      notificationModel.action="publication";
      // notificationModel.spec=
    }
    if(data['content']=='friendRequest.send')
    {
      notificationModel.action="users";
      notificationModel.data=User.fromJson(data['from']);
    }

    return notificationModel;
  }
}