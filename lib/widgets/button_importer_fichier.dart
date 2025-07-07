import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buttonImportFile({required label, double? size, required dynamic function}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    width: size,
    decoration: BoxDecoration(
        color: couleurPrincipale.withAlpha(40),
        borderRadius: BorderRadius.circular(28)),
    child: TextButton(
        onPressed: () async {
          await function();
        },
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: const BorderSide(
                width: 0, color: Color.fromRGBO(196, 196, 196, 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.file_upload_outlined,
              color: couleurPrincipale,
              size: 18,
            ),
            Text(
              label,
              style: GoogleFonts.roboto(
                  color: couleurPrincipale,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            )
          ],
        )),
  );
}
