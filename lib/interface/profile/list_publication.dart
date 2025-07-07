import 'package:application_amonak/data/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListePublication extends StatefulWidget {
  const ListePublication({super.key});

  @override
  State<ListePublication> createState() => _ListePublicationState();
}

class _ListePublicationState extends State<ListePublication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const SingleChildScrollView(
        child: Wrap(
          children: [
            // for(var item in DataController.publications)
            
          ],
        ),
      ),
    );
  }
}