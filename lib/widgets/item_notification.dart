import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/publication/details_publication.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemNotification extends StatefulWidget {
  final NotificationModel notification;
  final Function reloadNotificationData;
  const ItemNotification(
      {super.key,
      required this.notification,
      required this.reloadNotificationData});

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.notification.action == "users") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailsUser(user: widget.notification.data)));
        }
        if (widget.notification.action == "details_publication" &&
            widget.notification.idPub != null) {
          showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              context: context,
              builder: (context) =>
                  DetailsPublication(pubId: widget.notification.idPub!));
        }
        if (widget.notification.action == "share" &&
            widget.notification.idPub != null) {
          showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              context: context,
              builder: (context) =>
                  DetailsPublication(pubId: widget.notification.idPub!));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0x0f5f5f51),
            borderRadius: BorderRadius.circular(7)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 43,
                    height: 47,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: couleurPrincipale.withAlpha(40),
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      widget.notification.from!.userName![0],
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: couleurPrincipale),
                    ))),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 220,
                        decoration: const BoxDecoration(
                            // color: Colors.red
                            ),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: widget.notification.from!.userName,
                              style: GoogleFonts.roboto(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          TextSpan(text: '\t', style: GoogleFonts.roboto()),
                          TextSpan(
                              text: widget.notification.content,
                              style: GoogleFonts.roboto(fontSize: 12))
                        ])),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: Text(
                            "il y'a environ ${DataController.FormatDate(date: widget.notification.createAt!)} ",
                            style: GoogleFonts.roboto(fontSize: 13),
                          ))
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    title: Row(
                                      children: [
                                        Text(
                                          "Suppression",
                                          style: GoogleFonts.roboto(
                                              color: Colors.black),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.close,
                                                color: Colors.black))
                                      ],
                                    ),
                                    content: Container(
                                      child: Text(
                                        "Voulez-vvous effacer cette notification ?",
                                        style: GoogleFonts.roboto(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Annuler")),
                                      TextButton(
                                          onPressed: () {
                                            deleteNotification();
                                          },
                                          child: const Text("Confirmer"))
                                    ],
                                  );
                                });
                          },
                          child: Icon(Icons.close,
                              color: Colors.black.withAlpha(200), size: 21)),
                    ),
                  ],
                )
              ],
            ),
            // Divider(
            //   color: couleurPrincipale,
            //   thickness: 0.2,
            // )
          ],
        ),
      ),
    );
  }

  deleteNotification() {
    NotificationService.deleteNotification(widget.notification.id!)
        .then((value) {
      if (value.statusCode == 200) {
        successSnackBar(message: 'Notification effacée', context: context);
        setState(() {
          widget.reloadNotificationData();
        });
      } else {
        errorSnackBar(
            message: 'Erreur lors de la suppression de la notification',
            context: context);
      }
    }).catchError((e) {
      errorSnackBar(
          message: 'Erreur lors de la suppression de la notification',
          context: context);
    });
  }
}
