import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/file.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';

class MessageModel {
  late String id;
  late dynamic to;
  late dynamic from;
  late String content;
  late String date;
  late String type;
  late String status;
  late String deleters;
  late bool iSend = false;
  ArticleModel? publication;
  String? articleId;
  late List<Files> files = [];
  // MessageModel({
  //   required this.from,
  //   required this.to,
  //   required this.content,

  // });

  toJson() {
    return {
      'to': to,
      'from': from,
      'content': content,
      'files': files,
      'product': publication == null ? null : {"id": publication!.id}
    };
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
    messageModel.articleId = data['product'] ?? "";
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
    // messageModel.deleters=data['deleters'];
    messageModel.type = data['type'];
    if (data['files'].isNotEmpty) {
      for (var item in data['files']) {
        messageModel.files.add(Files.fromJson(item));
      }
    }

    // if (messageModel.articleId != "") {
    //   final pub = ProductService.getSingleArticle(id: messageModel.articleId)
    //       .then((value) {
    //     if (value.statusCode == 200) {
    //       messageModel.publication =
    //           Publication.fromJson(jsonDecode(value.body));
    //     }
    //   });
    // }

    print("Message content: ${messageModel.content} \n\n\n");

    return messageModel;
  }
}
