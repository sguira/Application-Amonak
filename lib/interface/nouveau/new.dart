import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/nouveau/add_publication.dart';
import 'package:application_amonak/interface/nouveau/add_vendeur.dart';
import 'package:application_amonak/interface/nouveau/create_alerte.dart';
import 'package:application_amonak/interface/nouveau/vendre_article.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: couleurPrincipale,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Voir nouveau",
                            style: GoogleFonts.roboto(
                                fontSize: 30,
                                color: const Color(0xffE8E9FF),
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Voir loin",
                            style: GoogleFonts.roboto(
                                fontSize: 30,
                                color: const Color(0xffE8E9FF),
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const ButtonNotificationWidget(
                      color: Colors.white,
                    )
                  ],
                ),
                if (DataController.user!.accountType != 'seller')
                  Container(
                      child: Row(
                    children: [
                      itemButtonWithIcon(
                          label: 'DEVENIR VENDEUR',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BecomeSeller()));
                          }),
                    ],
                  ))
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    itemButtonWithIcon(
                        label: 'Faire une alerte',
                        icon: Icons.campaign_rounded,
                        function: bottomSheetAlerte),
                    itemButtonWithIcon(
                        label: 'Vendre en live',
                        icon: Icons.favorite,
                        function: () {}),
                    itemButtonWithIcon(
                        label: 'Faire une publication',
                        icon: Icons.edit,
                        function: bottomSheetPublication),
                    itemButtonWithIcon(
                        label: 'Vendre un article',
                        icon: Icons.shopping_cart,
                        function: vendreArticle),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  vendreArticle() {
    return showCustomModalSheetWidget(context: context, child: VendreArticle());
  }

  itemButtonWithIcon(
      {required String label, IconData? icon, required Function function}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextButton(
          onPressed: () {
            function();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: const Color(0xff6151D4),
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                label,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff6151D4)),
              ),
            ],
          )),
    );
  }

  bottomSheetAlerte() {
    return showCustomModalSheetWidget(
        context: context,
        child: Container(
          constraints: BoxConstraints(maxHeight: ScreenSize.height * 0.8),
          child: const CreateAlertePage(),
        ));
  }

  bottomSheetPublication() {
    return showCustomModalSheetWidget(
        context: context,
        child: SingleChildScrollView(
          child: Container(
              constraints: BoxConstraints(maxHeight: ScreenSize.height * 0.7),
              child: const CreatePublication()),
        ));
  }
}
