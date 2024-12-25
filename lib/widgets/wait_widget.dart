

import 'package:application_amonak/colors/colors.dart';
import 'package:flutter/material.dart';
class WaitWidget extends StatelessWidget {
  const WaitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2, color: couleurPrincipale,
          )
        ],
      ),
    );
  }
}