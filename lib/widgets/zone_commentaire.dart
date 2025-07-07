import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextEditingController content = TextEditingController();
final keyForm = GlobalKey<FormState>();

Future<dynamic> zoneCommentaire(BuildContext context, Publication pub, String pubId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                headerBottomSheet(context, "Commentaires"),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        for (Commentaire com in pub.commentaires)
                          Container(
                            width: ScreenSize.width * 0.8,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: couleurPrincipale),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(com.content ?? '', style: GoogleFonts.roboto(fontSize: 14)),
                          ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewPadding.bottom
                          ),
                          child: _zoneSaisieCommentaire(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget _zoneSaisieCommentaire() {
  return Form(
    key: keyForm,
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: content,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer un commentaire";
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: 'Votre commentaire',
              hintStyle: GoogleFonts.roboto(fontSize: 12),
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          child: TextButton(
            onPressed: () {
              if (keyForm.currentState!.validate()) {
                ajouterCommentaire();
              }
            },
            child: Column(
              children: [
                const Icon(Icons.send),
                Text('Commenter', style: GoogleFonts.roboto(fontSize: 7)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void ajouterCommentaire() {
  Commentaire com = Commentaire();
  com.content = content.text;
  com.userId = DataController.user!.id;
  CommentaireService.saveComent(com).then((value) {
    // Ajouter un retour ou une mise à jour si nécessaire
    content.clear(); // Vider le champ après envoi
  });
}
