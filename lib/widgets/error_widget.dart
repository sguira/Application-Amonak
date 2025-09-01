import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? error;
  CustomErrorWidget({this.error}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 22),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: couleurPrincipale.withAlpha(40),
                    // ),
                    borderRadius: BorderRadius.circular(11)),
                child: Image.asset(
                  "assets/illustration/error_illustration.gif",
                  fit: BoxFit.cover,
                  width: 400,
                ),
              ),
            ),
            if (error != null)
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(
                  error!,
                  style: GoogleFonts.roboto(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      backgroundColor: couleurPrincipale,
                      padding: const EdgeInsets.all(8)),
                  child: Text(
                    "Réessayer...",
                    style:
                        GoogleFonts.roboto(fontSize: 13, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
