import 'dart:io';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/services/seller.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({super.key});

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  TextEditingController payement = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController numero = TextEditingController();
  File? pieceFile;
  File? articleFile;

  bool waitSend = false;

  final ImagePicker _picker = ImagePicker();

  int currentIndex = 1;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Devenir Vendeur'.toUpperCase(),
              style:
                  GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              child: Text(
                """Avec le profil vendeur, vos articles mis en vente pourront être payé directement en ligne ou à la livraison. Le client n’a plus besoin de vous contacter avant d’acheter. Vous bénéficiez par ailleurs de la possibilité de gérer et personnaliser votre boutique. Un profil vendeur, c’est l’équivalent d’un site e-commerce.
            Ce formulaire, permettra à notre équipe d’étudier votre profil afin de vous confirmer officiellement comme vendeur Amonak.""",
                style: GoogleFonts.roboto(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            containerFormulaire()
          ],
        ),
      ),
    );
  }

  containerFormulaire() {
    return Container(
      child: Column(
        children: [
          containerNext(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: currentIndex == 1
                ? containerForm()
                : currentIndex == 2
                    ? formContainerChoiceTypePayement()
                    : validationForm(),
          )
        ],
      ),
    );
  }

  containerNext() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemNext("Coordonnées", 1),
          itemNext("Rénumeration", 2),
          itemNext("Validation", 3)
        ],
      ),
    );
  }

  Container itemNext(String label, int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: index == currentIndex
                      ? const Color.fromARGB(255, 73, 21, 168)
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(86)),
              child: currentIndex == index
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(
              width: 4,
            ),
            SizedBox(
                width: 70,
                child: Text(
                  label,
                  style: GoogleFonts.roboto(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }

  containerForm() {
    return Container(
      child: Form(
        key: keyForm,
        child: Column(
          children: [
            Container(
              // height: 150,
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              child: TextFormField(
                // maxLength: 2500,
                // minLines: 5,
                controller: description,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'veuillez décrire en quelques lignes votre activité';
                  }
                  return null;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  label: const Text('Veuillez décrire votre boutique'),
                  hintText: 'Qu’est ce que vous souhaitez faire ?',
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(75, 0, 0, 0), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(50, 0, 0, 0), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // buttonImportFile(label:"Importer une pièce d'identité",icon: Icons.file_upload_outlined,onpressed: choiceFile('image',1) ),
                Container(
                  margin: const EdgeInsets.only(top: 14, bottom: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(width: 0.5)),
                  child: TextButton(
                      onPressed: () {
                        choiceFile('image', 1);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.file_upload_outlined),
                          const SizedBox(
                            width: 12,
                          ),
                          Text('Scanner une pièce d\'identité',
                              style: GoogleFonts.roboto(fontSize: 12)),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Passeport, CNI, permis de conduire... valide',
                    style: GoogleFonts.roboto(fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(width: 0.5)),
              child: TextButton(
                  onPressed: () {
                    choiceFile('image', 2);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.file_upload_outlined),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Veuillez Enregistrer une vidéo de vos articles",
                          style: GoogleFonts.roboto(fontSize: 12)),
                    ],
                  )),
            ),
            // buttonImportFile(label:"Veuillez importer une vidéo de vos articles",icon: Icons.file_upload_outlined,onpressed: choiceFile('video',2) )
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: TextButton(
                  onPressed: () {
                    if (keyForm.currentState!.validate()) {
                      if (pieceFile != null && articleFile != null) {
                        setState(() {
                          currentIndex = currentIndex + 1;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Veuillez entrée une pièce d\'identité')));
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Center(
                      child: Text(
                    "Continuez".toUpperCase(),
                    style: GoogleFonts.roboto(color: Colors.white),
                  ))),
            )
          ],
        ),
      ),
    );
  }

  buttonImportFile(
      {required label,
      required icon,
      required VoidCallback Function() onpressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
          onPressed: onpressed,
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(
                  width: 1, color: Color.fromRGBO(196, 196, 196, 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              Text(
                label,
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 12),
              )
            ],
          )),
    );
  }

  formContainerChoiceTypePayement() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Container(
            child: Text(
              "Comment souhaitez vous recevoir l’argent de vos acheté sur Amonak ?",
              style: GoogleFonts.roboto(fontSize: 14),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 22,
              spacing: 16,
              children: [
                itemTypePayement('Mtn Momo', 'mtn.jpg'),
                itemTypePayement('Orange Money', 'orange.png'),
                itemTypePayement('Wave', 'wave.png'),
                itemTypePayement('Orange Money', 'orange.png'),
                itemTypePayement('Wave', 'wave.png'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 36),
                width: ScreenSize.width * 0.8,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = currentIndex - 1;
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    child: Center(
                        child: Text(
                      "revenir".toUpperCase(),
                      style: GoogleFonts.roboto(color: Colors.black),
                    ))),
              ),
            ],
          )
        ],
      ),
    );
  }

  itemTypePayement(String label, String image) {
    return Container(
      // margin:const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = 3;
            description.text = label;
          });
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              width: 59,
              height: 59,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/medias/$image",
                    fit: BoxFit.cover,
                  )),
            ),
            Text(
              label,
              style:
                  GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  validationForm() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 28),
      child: Form(
        key: formKey2,
        child: Column(
          children: [
            itemTypePayement('Orange Money', 'orange.png'),
            itemForm(
                controller: numero,
                label: 'Numéro de téléphone',
                hint: 'Entrer le numéro de téléphone associé au compte'),
            itemForm(
                controller: name,
                label: 'Nom du proprietaire',
                hint: 'Entrer le nom associé au compte...'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: couleurPrincipale,
                      padding: const EdgeInsets.symmetric(vertical: 18)),
                  onPressed: () {
                    if (formKey2.currentState!.validate()) {
                      setState(() {
                        waitSend = true;
                      });
                      Map data = {
                        "email": DataController.user!.email,
                        "phone": numero.text,
                        "address": DataController.user!.address,
                        "message": description.text,
                        "adress": {
                          'countryName': 'Côte d\'idvoire',
                          'state': 'Abidjan',
                          'countryCode': '225',
                          'city': "Abidjan",
                        }
                      };
                      SellerService.addSeller(data, articleFile!).then((value) {
                        if (value == "OK") {
                          setState(() {
                            waitSend = false;
                          });
                          print("REPONSE $value");
                          // Future.delayed(const Duration(milliseconds: 800),(){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage() ));
                          // });
                        }
                      });
                    }
                  },
                  child: Center(
                      child: waitSend == false
                          ? Text(
                              "Envoyer".toUpperCase(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            )
                          : const SizedBox(
                              width: 18,
                              height: 18,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                            ))),
            )
          ],
        ),
      ),
    );
  }

  Container itemForm(
      {TextEditingController? controller, required hint, required label}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      // height: 42,
      child: TextFormField(
        controller: controller,
        focusNode: FocusNode(),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Champ réquis';
          }
          return null;
        },
        // autofocus: true,
        // cursorHeight: 16,
        cursorWidth: 2,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.roboto(fontSize: 12),
          labelStyle: GoogleFonts.roboto(fontSize: 12),
          label: Text(
            label,
            style: GoogleFonts.roboto(fontSize: 11),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(36),
              borderSide: const BorderSide(color: Colors.black26)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(36),
              borderSide: const BorderSide(color: Colors.black26)),
        ),
      ),
    );
  }

  choiceFile(String type, int count) async {
    final XFile? file;

    if (type == 'image') {
      file = await _picker.pickImage(source: ImageSource.gallery);
      print("nom de fichier ${file!.path}");
    } else {
      file = await _picker.pickVideo(source: ImageSource.gallery);
    }
    if (file != null) {
      setState(() {
        if (count == 1) {
          pieceFile = File(file!.path);
        } else {
          articleFile = File(file!.path);
        }
        print("File ok");
      });
    }
  }
}
