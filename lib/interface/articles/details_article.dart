import 'package:application_amonak/interface/vendre/WidgetVenteContainer.dart';
import 'package:application_amonak/interface/vendre/vendre.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/gradient_button.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 

class DetailArticle extends StatefulWidget {
  final ArticleModel  article;
  const DetailArticle({super.key,required this.article});

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {

  TextEditingController livraison=TextEditingController();
  TextEditingController frais=TextEditingController();

  double montantTotal=10000;
  double fraisLivraison=14000;
  double livraisonMontant=1000;
  bool viewBottom=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomSheet:viewBottom?  bottomContainer(context):null,
      resizeToAvoidBottomInset: true,
      
      body: Stack(
        fit: StackFit.expand,
        children: [
          
          Positioned.fill(
            // top: 20,
            child: Container(
              // height: ScreenSize.height*0.98,
              // width: ,
              child: Image.asset("assets/medias/articles/article2.jpg",fit: BoxFit.cover,))),
          Positioned(
            bottom: 10,
            left: ScreenSize.width*0.45,
            child: Container(
              alignment: Alignment.center,
              child: IconButton(onPressed: (){
                setState(() {
                  viewBottom=true;
                });
              }, icon:const Icon(Icons.keyboard_double_arrow_up_sharp)),
            ),
          ), 
          Positioned(
            top: 8,
            child: Container(
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:const Icon(Icons.arrow_back)),
            )
          )
           
          
        ],
      ),
    );
  }

  Widget bottomContainer(BuildContext context) {
    return Container(
      
      padding:const EdgeInsets.symmetric(vertical: 18,horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                
                Container(
                  width: ScreenSize.width*0.8,
                  child: Column(
                    children: [
                      articleContent(),
                      formContainer(context)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    buttonSection()
                  ],
                ), 
              ],
            ),
            buttonJeveux(context)
          ],
        ),
      ),
    );
  }

  Container formContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
            child: Column(
              children: [
                TextFieldDisable(label: "Livraison", value: NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.article.currency).format(widget.article.livraison)), 
                TextFieldDisable(label: "Frais", value: NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.article.currency).format(widget.article.frais)), 

                TextFieldDisable(label: "Montant Total", value: NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.article.currency).format(widget.article.total)), 

                
              ],
            )
          );
  }

  Container buttonJeveux(BuildContext context) {
    return Container(
                margin:const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: linearGradient, 
                  borderRadius: BorderRadius.circular(36)
                ),
                child: Center(child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> VendrePage(article:widget.article,articleId: null, )));
                }, child: Text("Je veux ça !".toUpperCase(),style: GoogleFonts.roboto(color: Colors.white),))),
              );
  }

  Column buttonSection() {
    return Column(
              children: [
                IconButton(onPressed: (){
                  // Navigator.pop(context); 
                  setState(() {
                    viewBottom=false;
                  });
                }, icon:const Icon(Icons.close)),
                Container(
                  margin:const EdgeInsets.only(top: 26),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){}, icon:const Icon(Icons.favorite)),
                      Text(NumberFormat.currency(locale: 'fr',symbol: '',decimalDigits: 0).format(100),style: GoogleFonts.roboto(fontSize:9),)
                    ],
                  )),
                Container(
                  margin:const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.comment)),
                      Text(NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: '').format(200),style: GoogleFonts.roboto(fontSize: 9),)
                    ],
                  )),
              ],
                              );
  }

  Column articleContent() {
    return Column(
                mainAxisAlignment: MainAxisAlignment.start, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12,),
                  Container(
                    child: Text(NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: widget.article.currency).format(widget.article.price!),style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w800),),
                  ),
                  Container(
                    margin:const EdgeInsets.symmetric(vertical: 6),
                    child: Text(widget.article.name!,style:GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                  ),
                  if(widget.article.content!=null)
                  TextExpanded(texte: widget.article.content!)]
    );
  }

  Container itemForm(
    {
      required String label, 
      required String hint, 
      required TextEditingController controller
    }
  ) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: controller,
                      style: GoogleFonts.roboto(fontSize: 12),
                      
                      decoration: InputDecoration(
                        contentPadding:const EdgeInsets.symmetric(vertical: 4),
                        label: Text(label,style: GoogleFonts.roboto(),),
                        hintText: NumberFormat.currency(locale: 'fr',decimalDigits: 0,symbol: 'CFA').format(double.parse(hint)),
                        hintStyle: GoogleFonts.roboto(color: Colors.black),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,width: 3),
                        ), 
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 2),
                        )
                      ),
                    ),
                  );
  }

  viewModal(){
    return showModalBottomSheet(context: context, builder: (context)=>Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            headerBottomSheet(context, '')
          ],
        ),
      ),
    ));
  }
}