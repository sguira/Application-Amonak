import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  String description="Veuillez définir un nouveau mot de passe et le confirmer.";
  String title="Réinitialiser votre mot de passe";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          Container(
            margin:const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 12),
                      child: Text(title,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,letterSpacing: 1),),
                    ),
                    Container(
                      width: ScreenSize.width*0.75,
                      child: Text(description,style: GoogleFonts.roboto(fontSize: 13),)
                    )
                    
                  ],
                ), 
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 16),
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon:const Icon(Icons.close)))
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                itemForm(label: "Entrez le nouveau mot de passe",hint: 'Ecrire..'),
                itemForm(label: "Veuillez Confirmer le mot de passe",hint: 'Ecrire..')
              ],
            ),
          ), 
          Container(
            margin:const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
            padding:const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: linearGradient, 
              borderRadius: BorderRadius.circular(36)
            ),
            child: Center(child: TextButton(onPressed: (){}, child: Text("Confirmer".toUpperCase(),style: GoogleFonts.roboto(color: Colors.white)),)),
          )
        ],
      ),
    );
  }

  Container itemForm(
    {
      required String label, 
      required String hint, 
    
    }
  ) {
    return Container(
                margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,style: GoogleFonts.roboto(fontSize: 12,letterSpacing: 1),),
                    TextFormField(
                      decoration: InputDecoration(
                        
                        hintText: hint,
                        hintStyle: GoogleFonts.roboto(fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        )
                      ),
                    ),
                  ],
                ),
              );
  }
}