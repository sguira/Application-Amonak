import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ShareWidget extends StatefulWidget {
  const ShareWidget({super.key, required this.itemPub, required});

  final Publication itemPub;

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  PublicationSocket? publicationSocket;

  bool waitShare = false;
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    publicationSocket = PublicationSocket();

    publicationSocket!.socket!.onConnect((handler) {
      print("Socket connecté");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(
                //   width: 0.2,
                //   color: couleurPrincipale,
                // )),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(width: 2, color: couleurPrincipale)),
                    child: ClipOval(
                      child: DataController.user!.avatar!.isEmpty
                          ? Image.asset(
                              "assets/medias/profile.jpg",
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            )
                          : Image.network(
                              DataController.user!.avatar!.first.url!,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/medias/profile.jpg",
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                );
                              },
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      DataController.user!.userName!,
                      style: GoogleFonts.roboto(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: TextFormField(
                controller: message,
                minLines: 2,
                maxLines: 8,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  // filled: true,
                  // fillColor: Colors.white,
                  hintText: 'Votre message',

                  enabledBorder: UnderlineInputBorder(
                      // borderRadius: BorderRadius.circular(4),
                      borderSide:
                          const BorderSide(color: couleurPrincipale, width: 2)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: couleurPrincipale,
                      borderRadius: BorderRadius.circular(36)),
                  child: waitShare == false
                      ? TextButton(
                          onPressed: () {
                            Map<String, dynamic> shareData = {
                              'user': DataController.user!.id,
                              'share': widget.itemPub.id,
                              'type': 'share',
                              'statut': true,
                              'shareMessage': message.text
                            };

                            Map<String, dynamic> notification = {
                              'to': widget.itemPub.user!.id,
                              'from': DataController.user!.id,
                              'type': "share",
                              "publication": widget.itemPub.id
                            };

                            setState(() {
                              waitShare = true;
                            });
                            PublicationService.sharePublication(data: shareData)
                                .then((value) {
                              waitShare = false;
                              if (value.statusCode == 200) {
                                NotificationService.addNotification(
                                    notification);
                                publicationSocket!.socket!.onConnect((handler) {
                                  publicationSocket!
                                      .emitCreation(event: '', data: shareData);
                                });
                                successSnackBar(
                                    message: 'Publication partagée',
                                    context: context);
                              } else {
                                errorSnackBar(
                                    message: "Une erreur est survenue",
                                    context: context);
                              }
                              Navigator.pop(context);
                            }).catchError((e) {
                              waitShare = false;
                              errorSnackBar(
                                  message: "Une erreur est survenue",
                                  context: context);
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Partager",
                                style: GoogleFonts.roboto(color: Colors.white),
                              )
                            ],
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(6),
                              width: 22,
                              height: 22,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
