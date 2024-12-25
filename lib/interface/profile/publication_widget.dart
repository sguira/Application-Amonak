import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 


class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          for(var item in DataController.articles)
          Container(
            width: ScreenSize.width*0.5,
            height: ScreenSize.width*0.5,
            child: Image.network("https://picsum.photos/200/300",fit: BoxFit.cover,),
          )
        ],
      ),
    );
  }
}