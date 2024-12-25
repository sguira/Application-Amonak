import 'package:application_amonak/interface/vendre/congrat.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class VenteContenu extends StatefulWidget {
  final  articleModel;
  const VenteContenu({super.key,required this.articleModel});

  @override
  State<VenteContenu> createState() => _VenteContenuState();
}

class _VenteContenuState extends State<VenteContenu> {

  int currentIndex=1;

  TextEditingController description=TextEditingController();
  TextEditingController prix=TextEditingController();
  TextEditingController livraison=TextEditingController();
  TextEditingController frais=TextEditingController();
  TextEditingController vendeur=TextEditingController();
  TextEditingController montant=TextEditingController(text: "7000");

  TextEditingController telephoneAcheteur=TextEditingController();
  TextEditingController nomAcheteur=TextEditingController();
  TextEditingController adresse=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return  Container(
          margin:const EdgeInsets.symmetric(horizontal: 22),
          child: ListView(
            children: [
              Container(
                child:Column( 
                  children: [
                    Text("Acheter".toUpperCase(),style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w800),), 
                    Container(
                      child: Text(""" Faites vos achats en toute sérénité car le vendeur a un profil confirmé par Amoanak. Tous vos articles achetés ont une garantie minimum de 24h.""",style: GoogleFonts.roboto(fontSize: 12),textAlign: TextAlign.center,),
                    )
                  ],
                )
              ),
              containerNext(),
        
              AnimatedSwitcher(
                duration:const Duration(milliseconds: 800), 
                child:currentIndex==1? containerFormulaire(): currentIndex==2? payementContainer(): Container(
                  child: Column(
                    children: [
                      Container(
                        child: titrePayement(),
                      ), 
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Par quel moyen souhaitez vous payer ?",style: GoogleFonts.roboto(fontWeight: FontWeight.w700),),
                      ),
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 12),
                        child: Image.asset("assets/medias/orange.png",width: 100,),
                      ), 
                      Container(
                        child: Column(
                          children: [
                            textFormField2(label: 'Numéro de téléphone',controller: telephoneAcheteur,hint: 'Entrez le numéro associé au compte'), 
                            textFormField2(label: 'Nom du propriétaire',controller: nomAcheteur,hint: 'Entrez le nom associé au compte'), 
                            textFormField2(label: 'Votre adresse',controller: adresse,hint: 'Défini')
                          ],
                        ),
                      ), 
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: linearGradient, 
                          borderRadius: BorderRadius.circular(36)
                        ),
                        child: TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CongratSeller() ));
                        }, child: Center(child: Text('Payer'.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),))),
                      ), 
                      TextButton(onPressed: (){
                        setState(() {
                          currentIndex-=1;
                        });
                      }, child: Text('Revenir'.toUpperCase(),style: GoogleFonts.roboto(),))
                    ],
                  ),
                ),
              )
            ],
          ),
        );
  }

  Container textFormField2(
    {
      required TextEditingController controller, 
      required String label, 
      required String hint
    }
  ) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 4),
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              contentPadding:const EdgeInsets.symmetric(horizontal: 18),
                              hintText: hint,
                              hintStyle: GoogleFonts.roboto(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36),
                              ), 
                              label: Text(label,style: GoogleFonts.roboto(fontSize: 12),)
                            ),
                          ),
                        );
  }

  Container payementContainer() {
    return Container(
              child: Column(
                children: [
                  titrePayement(), 
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 22),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: [
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),
                        itemTypeVente("Orange Money","assets/medias/orange.png",""),

                      ],
                    ),
                    
                  ),
                  // Spacer(),
                  const SizedBox(height: 36,),
                  Container(
                    child: TextButton(onPressed: (){
                      setState(() {
                        currentIndex-=1;
                      });
                    }, child: Text("Revenir".toUpperCase(),style: GoogleFonts.roboto(),)),
                  )
                ],
              ),
            );
  }

  Container titrePayement() {
    return Container(
                  margin:const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ScreenSize.width*0.28,
                        height: 1, 
                        color: Colors.black12,
                      ), 
                      Text("Payer en ligne".toUpperCase(),style:GoogleFonts.roboto()),
                      Container(
                        width: ScreenSize.width*0.28,
                        height: 1, 
                        color: Colors.black12,
                      )
                    ],
                  ),
                );
  }

  Widget itemTypeVente(String label,String image,String value) {
    return GestureDetector(
      onTap: (){
        setState(() {
          currentIndex+=1;
        });
      },
      child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1, 
                                color: Colors.black12, 
                                
                              ), 
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Column(
                              children: [
                                Image.asset(image,width: 82,),
                                SizedBox(height: 4,), 
                                Text(label,style: GoogleFonts.roboto(fontSize:12),)
                              ],
                            ),
                          ),
    );
  }

  Container containerFormulaire() {
    // TextEditingController frais =TextEditingController();
    prix.text=NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.articleModel!.currency).format(widget.articleModel!.price);
    nomAcheteur.text=widget.articleModel.user!.userName.toString();
    description.text=widget.articleModel!.content??'';
    livraison.text=NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.articleModel!.currency).format(widget.articleModel!.livraison);
    frais.text=NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.articleModel!.currency).format(widget.articleModel!.frais);
    TextEditingController total=TextEditingController(
      text: NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.articleModel!.currency!).format(
        widget.articleModel!.price! + widget.articleModel!.livraison! +widget.articleModel!.frais!
      )
    );
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description",style: GoogleFonts.roboto(),), 
                      TextExpanded(texte: description.text), 
                      Container(
                        height: 2, 
                        width: ScreenSize.width, 
                        color: Colors.black
                      )
                    ],
                  ),
                ),
                TextFieldDisable(label: 'Prix', value: prix.text), 
                TextFieldDisable(label: 'Vendeur', value: nomAcheteur.text), 
                TextFieldDisable(label: 'Livraison', value: livraison.text), 
                TextFieldDisable(label: 'Frais', value: frais.text), 
                // TextFieldDisable(label: 'Total', value: total.text), 
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.black, 
                    borderRadius: BorderRadius.circular(36)
                  ),
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        currentIndex+=1;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    child: Center(child: Text("Continuer".toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),))),
                )
              ],
            ),
          );
  }

  containerNext(){
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 18,horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemNext("Coordonnées",1), 
          itemNext("Rénumeration",2), 
          itemNext("Validation",3)
        ],
      ),
    );
  }

  Container itemNext(String label,int index) {
    return Container(
          child: GestureDetector(
            onTap: (){
              setState(() {
                currentIndex=index;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25, 
                  height: 25, 
                  decoration: BoxDecoration(
                    color:index==currentIndex?const Color.fromARGB(255, 73, 21, 168): Colors.black12,
                    borderRadius: BorderRadius.circular(86)
                  ),
                  child:currentIndex==index?const Icon(Icons.check,color:Colors.white,size: 16,):null,
                ),
                const SizedBox(width: 4,),
                Container(
                  width: 70,
                  child: Text(label,style: GoogleFonts.roboto(fontSize: 12),overflow: TextOverflow.ellipsis,) )
              ],
            ),
          ),
        );
  }

}

class TextFieldDisable extends StatelessWidget {
  const TextFieldDisable({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 6),
      margin:const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.roboto(),), 
          Container(
            margin:const EdgeInsets.only(top: 8),
            child: Text(value,style: GoogleFonts.roboto(fontWeight: FontWeight.w500),),
          ), 
          const Divider(
            thickness: 2, 
            color: Colors.black,
          )
        ],
       ),
    );
  }
}