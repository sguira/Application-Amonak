import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ButtonLike extends StatefulWidget {
  final dynamic pub;
  final Color? color;
  const ButtonLike({super.key, required this.pub, this.color});

  @override
  State<ButtonLike> createState() => _ButtonLikeState();
}

class _ButtonLikeState extends State<ButtonLike> {
  bool isLiked = false;
  int likes = 0;
  String idLike = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNombreLike();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          IconButton(
              onPressed: () {
                if (!isLiked == false && idLike.isNotEmpty) {
                  deleteLike();
                } else {
                  likePublication();
                }
              },
              icon: Icon(
                !isLiked ? Icons.favorite_border : Icons.favorite,
                color: isLiked ? Colors.red : widget.color,
              )),
          Text(
            NumberFormat.currency(locale: 'fr', decimalDigits: 0, symbol: '')
                .format(likes),
            style: GoogleFonts.roboto(color: widget.color),
          )
        ],
      ),
    );
  }

  getNombreLike() async {
    await PublicationService.getNumberLike(widget.pub.id!, 'like')
        .then((value) {
      if (value!.statusCode == 200) {
        setState(() {
          likes = (jsonDecode(value.body) as List).length;
          print("nombre de like $likes\n\n $isLiked");
        });

        if (likes > 0) {
          for (var i in jsonDecode(value.body) as List) {
            if (i['user'] != null) {
              if (i['user']['_id'] == DataController.user!.id) {
                setState(() {
                  isLiked = true;
                  idLike = i['_id'];
                });
              }
            }
          }
        }
      }
    }).catchError((e) {
      setState(() {
        isLiked = false;
        likes = 0;
      });
      print("ERORRRT $e \n\n");
    });
  }

  likePublication() async {
    Map data = {
      "publication": widget.pub.id,
      "user": DataController.user!.id,
      // "type":'like'
    };
    Map<String, dynamic> notificationData = {
      "publication": widget.pub.id,
      "from": DataController.user!.id,
      "type": 'like',
      "to": widget.pub.user!.id,
      "content": "publicationBackend.likeYourPublication"
    };
    if (isLiked == false) {
      setState(() {
        isLiked = true;
        likes += 1;
      });
      await PublicationService.addLike(data).then((value) {
        print("Status like ${value.statusCode}\n\n");
        getNombreLike();
        if (value.statusCode != 200) {
          setState(() {
            isLiked = false;
            likes -= 1;
          });
        } else {
          NotificationService.addNotification(notificationData).then((value) {
            // print(value.body);
          }).catchError((e) {
            print("ERORRRT $e \n\n");
          });
        }
      }).catchError((e) {
        setState(() {
          isLiked = false;
          likes -= 1;
        });
      });
    }
  }

  deleteLike() async {
    if (isLiked) {
      await PublicationService.deleteLike(idLike).then((value) {
        print("SUppression like ${value.statusCode} .. \n\n");
        setState(() {
          isLiked = false;
          likes -= 1;
          getNombreLike();
        });
        if (value.statusCode.toString() != '200') {
          setState(() {
            isLiked = true;
            likes += 1;
          });
        }
      }).catchError((e) {
        setState(() {
          isLiked = true;
          likes += 1;
        });
      });
    }
  }
}
