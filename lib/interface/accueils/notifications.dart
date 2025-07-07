import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationModel> notification = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder(
          future: NotificationService.getNotification().then((value) {
            if (value!.statusCode == 200) {
              notification = [];
              print((jsonDecode(value.body) as List).length);
              for (var item in jsonDecode(value.body) as List) {
                notification.add(NotificationModel.fromJson(item));
              }
            }
          }).catchError((e) {
            print("Errorr $e");
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  child: const SpinKitWaveSpinner(color: couleurPrincipale));
            }
            if (snapshot.hasError) {
              return const Text("Error");
            }
            return Container(
              child: ListView.builder(
                itemCount: notification.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 16, top: 8, right: 6, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.black.withAlpha(18),
                        borderRadius: BorderRadius.circular(11)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          // width: 50,
                          // height: 50,

                          child: Icon(
                            notification[index].type == 'like'
                                ? Icons.favorite
                                : notification[index].type == 'comment'
                                    ? Icons.comment
                                    : Icons.shopping_cart,
                            color: couleurPrincipale,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          // color: Colors.red,
                          width: ScreenSize.width * 0.72,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  notification[index].title!,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (notification[index].content!.isNotEmpty)
                                SizedBox(
                                  // margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: ScreenSize.width * 0.65,
                                  // color: Colors.black,
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text:
                                            notification[index].from!.userName!,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500)),
                                    if (notification[index].content != null)
                                      TextSpan(
                                        text: notification[index].content ==
                                                "comment.likeYourComment"
                                            ? "Vient de liker votre commentaire"
                                            : notification[index].content ==
                                                    "comment.commentYourPublication"
                                                ? "Vient de commenter votre publication"
                                                : "",
                                        style: GoogleFonts.roboto(fontSize: 11),
                                      )
                                  ])),
                                )
                            ],
                          ),
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Icon(Icons.info),
                        //   ],
                        // )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    ));
  }
}
