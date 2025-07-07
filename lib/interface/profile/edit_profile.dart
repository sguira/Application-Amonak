import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/profil.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController description=TextEditingController(
    text: DataController.user!.description
  );

  TextEditingController nom=TextEditingController(text: DataController.user!.userName); 
  TextEditingController email=TextEditingController(text: DataController.user!.email);
  // TextEditingController password=TextEditingController(text: "0000000");
  bool waitUpdate=false;
  final keyUpdate=GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataController.user!.afficherUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(Icons.arrow_back)
        ),
        title: Container(
          margin:const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Gérer',style: GoogleFonts.roboto(decoration: TextDecoration.underline,fontSize: 14,fontWeight: FontWeight.w500),)
            ],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              alignment: Alignment.center,
              child: Text("Modifier Mon profil".toUpperCase(),style: GoogleFonts.roboto(fontWeight: FontWeight.w600),),
            ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, 
                  height: 100,
                  // alignment: Alignment.center,
                  padding:const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 4,color: couleurPrincipale), 
                    borderRadius: BorderRadius.circular(86)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(86),

                    child:DataController.user!.avatar!.isEmpty? Image.asset("assets/medias/user.jpg",fit: BoxFit.cover,):Image.network(DataController.user!.avatar!.last.url!),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin:const EdgeInsets.only(top: 12), 
              
              child: Text(DataController.user!.userName!.toUpperCase(),style: GoogleFonts.roboto(fontSize:14,letterSpacing:2,fontWeight:FontWeight.w700),),
            ),
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 32,vertical: 18),
              child: Form(
                key: keyUpdate,
                child: Column(
                  children: [
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: description,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Veuillez entrer votre description';
                          }
                          return null;
                        },
                        maxLines: 4,
                        style: GoogleFonts.roboto(fontSize:12),
                        decoration: InputDecoration(
                          hintText: 'Biographie',
                
                          hintStyle: GoogleFonts.roboto(fontSize: 12), 
                          label: Text('Bibliographie',style: GoogleFonts.roboto(fontSize: 14),),
                          
                          border:const OutlineInputBorder(
                
                          )
                        ),
                      ),
                    ), 
                    itemForm(controller: nom, label: 'Nom Entreprise', hint: ''), 
                    itemForm(controller: email, label: 'Email entreprise', hint: ''), 
                    const SizedBox(height: 18,), 
                    // GradientButton(label: "Mettre à jour",key: keyUpdate,onPressed: updateForm ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        gradient:const LinearGradient(colors: [
                        Color.fromRGBO(97, 81, 212, 1), 
                      // Color.fromARGB(255, 9, 51, 189),
                        Color.fromRGBO(132, 62, 201, 1)
                        ])
                      ),
                      child: Center(
                        child: TextButton(
                          
                          onPressed:(){
                            if(keyUpdate.currentState!.validate()){
                              updateForm();
                            }
                          } ,
                          child:waitUpdate==false? Text("Mettre à jour".toUpperCase(),style:GoogleFonts.roboto(fontSize:12,color:Colors.white)):const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,),)
                        ),
                      ),
                    )
                
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  itemForm({
    required TextEditingController controller, 
    required String label, 
    required String hint
  }){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        
        validator: (value){
          if(value!.isEmpty){
            return 'Veuillez entrer votre $label';
          }
          return null;
        },
        style: GoogleFonts.roboto(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint, 
          label: Text(label,style: GoogleFonts.roboto(fontSize: 12),), 
          border:const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black12
            )
          )
        ),
      ),
    );
  }

  updateForm(){
    
    User u=DataController.user!;
    u.userName=nom.text;
    u.description=description.text;
    // u.email=email.text;
    Map data={
      "userName":nom.text,
      "description":description.text,
      "email":email.text
    };
    setState(() {
      waitUpdate=true;
    });
    ProfilService.upadteProfil(data).then((value){
      setState(() {
        waitUpdate=false;
      });
      print("Valeur $value");
      if(value=="OK"){
        setState(() {
          DataController.user=u;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil modifié")));
      }
      else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Une erreur est survenue?")));

      }
    });
  }
}