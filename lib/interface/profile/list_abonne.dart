import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/widgets/follow_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAbonnee extends StatefulWidget {
  const ListAbonnee({super.key});

  @override
  State<ListAbonnee> createState() => _ListAbonneeState();
}

class _ListAbonneeState extends State<ListAbonnee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            // for(var item in DataController.personnes)
            // FollowUserWidget(item)
          ],
        ),
      ),
    );
  }
}