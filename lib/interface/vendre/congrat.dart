import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratSeller extends StatefulWidget {
  const CongratSeller({super.key});

  @override
  State<CongratSeller> createState() => _CongratSellerState();
}

class _CongratSellerState extends State<CongratSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:const EdgeInsets.symmetric(vertical: 26,horizontal: 28),
        child: ListView(
          children: [
            const SizedBox(height: 32,),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(width: 4)
                    ),
                    child:const Icon(Icons.check,size: 100,color: Colors.green,),
                  ),
                ],
              ),
            ), 
            Container(
              margin:const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Félicitations !".toUpperCase(),style: GoogleFonts.roboto(fontWeight: FontWeight.bold),), 
                  Container(
                    margin:const EdgeInsets.symmetric(vertical: 12),
                    child: Text(""" Votre article a été payé avec succès. Le livreur vous l’enverra très bientôt. En attendant vous pouvez voir d’autres contenus qui pourraient vous intéresser. """,style: GoogleFonts.roboto(fontSize: 12),textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
            const SizedBox(height: 36,),
            Container(
              decoration: BoxDecoration(
                color: Colors.black, 
                borderRadius: BorderRadius.circular(36)
              ),
              child: Center(child: TextButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: Text("OKAY",style: GoogleFonts.roboto(color: Colors.white),))),
            )
          ],
        ),
      ),
    );
  }
}