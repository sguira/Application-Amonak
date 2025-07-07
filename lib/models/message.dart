import 'dart:io';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/file.dart';
import 'package:application_amonak/models/user.dart';

class MessageModel {
  late String id;
  late dynamic to;
  late dynamic from;
  late String content;
  late String date;
  late String publication;
  late String type;
  late String status;
  late String deleters;
  late bool iSend = false;
  late List<Files> files = [];
  // MessageModel({
  //   required this.from,
  //   required this.to,
  //   required this.content,

  // });

  toJson() {
    return {'to': to, 'from': from, 'content': content, 'files': files};
  }

  static loadFile(List<Map<String, dynamic>> files) {
    List<Files> listFiles = [];
    for (Map<String, dynamic> item in files as List) {
      listFiles.add(Files.fromJson(item));
    }
    return listFiles;
  }

  static MessageModel fromJson(Map data) {
    MessageModel messageModel = MessageModel();
    messageModel.id = data['_id'];

    // print("nom ${data['from']['userName']}\n\n\n");
    try {
      messageModel.to = User.fromJson(data['to']);
    } catch (e) {
      messageModel.to = data['to'];
      print("Error contenu $e");
    }
    try {
      messageModel.from = User.fromJson(data['from']);
      messageModel.iSend =
          messageModel.from.id == DataController.user!.id ? true : false;
    } catch (e) {
      messageModel.from = data['from'];
      messageModel.iSend =
          messageModel.from == DataController.user!.id ? true : false;
    }

    messageModel.content = data['content'];
    messageModel.type = data['type'];
    // messageModel.deleters=data['deleters'];
    messageModel.type = data['type'];
    if (data['files'].isNotEmpty) {
      for (var item in data['files']) {
        messageModel.files.add(Files.fromJson(item));
      }
    }
    // messageModel.status=data['status'];
    // messageModel.publication=data['publication'];

    return messageModel;
  }
}
