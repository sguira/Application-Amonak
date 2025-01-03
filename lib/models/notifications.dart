import 'package:application_amonak/models/user.dart';
import 'package:intl/intl.dart';
class NotificationModel{
  late String? id;
  late String? content;
  late User? from;
  late String? type;
  late String? createAt;
  late String? like;
  late String? title;
  static fromJson(Map data){
    NotificationModel notificationModel=NotificationModel();
    notificationModel.id=data['_id'];
    notificationModel.content=data['content']??'';
    notificationModel.type=data['type'];
    // notificationModel.createAt=DateFormat("yyyyy-MM-dd HH:mm").format(data['createdAt']);
    notificationModel.from=User.fromJson(data['from']);
    notificationModel.title=data['type']=='like'?"Like":"Commentaire";
    return notificationModel;
  }
}