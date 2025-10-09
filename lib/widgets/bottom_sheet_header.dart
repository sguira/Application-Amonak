import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container headerBottomSheet(BuildContext context, String texte) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const Spacer(flex: 2,),
        Text(
          texte.toUpperCase(),
          style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const Spacer(),
        Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)))
      ],
    ),
  );
}
