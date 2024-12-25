import 'package:application_amonak/models/user.dart';

class MessageModel{
  late String id;
  late User to;
  late User from;
  late String content;
  late String date;
  late String publication;
  late String type;
  late String status;
  late String deleters;

  // MessageModel({
  //   required this.from, 
  //   required this.to, 
  //   required this.content, 
    
  // });

  toJson(){
    return {
      'to':to, 
      'from':from,
      'content':content
    };
  }
  static MessageModel fromJson(Map data){
    MessageModel messageModel=MessageModel();
    messageModel.id=data['_id'];
    messageModel.from=User.fromJson(data['from']);
    messageModel.to=User.fromJson(data['to']);
    messageModel.content=data['content'];
    messageModel.deleters=data['deleters'];
    messageModel.type=data['type'];
    messageModel.status=data['status'];
    // messageModel.publication=data['publication'];
    
    return messageModel;
  }
}