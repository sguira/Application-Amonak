import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Portefeuille extends StatefulWidget {
  const Portefeuille({super.key});

  @override
  State<Portefeuille> createState() => _PortefeuilleState();
}

class _PortefeuilleState extends State<Portefeuille> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "La valeur acuelle de votre portefeuille est de:",
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Text(
                  "0.00 XOF",
                  style: GoogleFonts.roboto(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: couleurPrincipale),
                ),
                Text("Maintenant",
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: couleurPrincipale)),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Vous pouvez tranferer les fonds sur votre compte principal en cliquant sur le bouton ci-dessous. Amonak ne prend aucune commission sur les tranferts.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Text("0.00 XOF",
                    style: GoogleFonts.roboto(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: couleurPrincipale)),
                Text(
                  "Après livraison",
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: couleurPrincipale),
                )
              ],
            ),
          ),
          Container(
              child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: couleurPrincipale,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36))),
                  onPressed: () {},
                  child: Text('RETIRER MAINTENANT',
                      style: GoogleFonts.roboto(
                          fontSize: 16, color: Colors.white)))),
        ],
      ),
    ));
  }
}
