import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/publication/details_publication.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemNotification extends StatefulWidget {
  final NotificationModel notification;
  const ItemNotification({
    super.key,
    required this.notification,
  });

  @override
  State<ItemNotification> createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.notification.action == "users") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsUser(user: widget.notification.data),
            ),
          );
        }
        if ((widget.notification.action == "details_publication" ||
                widget.notification.action == "share") &&
            widget.notification.idPub != null) {
          showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              context: context,
              builder: (context) =>
                  DetailsPublication(pubId: widget.notification.idPub!));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image ou icône de l'utilisateur
            CircleAvatar(
              radius: 25,
              backgroundColor: couleurPrincipale.withOpacity(0.1),
              child: Text(
                widget.notification.from!.userName![0].toUpperCase(),
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: couleurPrincipale,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Texte de la notification
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.notification.from!.userName,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: widget.notification.content,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "il y a environ ${DataController.FormatDate(date: widget.notification.createAt!)}",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton de suppression
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text("Suppression"),
                    content:
                        const Text("Voulez-vous effacer cette notification ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          deleteNotification();
                        },
                        child: const Text("Confirmer"),
                      ),
                    ],
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, color: Colors.black54, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction de suppression de la notification (inchangée)
  deleteNotification() {
    NotificationService.deleteNotification(widget.notification.id!)
        .then((value) {
      if (value.statusCode == 200) {
        // ... (gestion du succès)
      } else {
        // ... (gestion de l'erreur)
      }
    }).catchError((e) {
      // ... (gestion de l'erreur)
    });
  }
}
