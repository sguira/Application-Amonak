import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ListAchat extends StatefulWidget {
  const ListAchat({super.key});

  @override
  State<ListAchat> createState() => _ListAchatState();
}

class _ListAchatState extends State<ListAchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: [
            Text('Liste des achats',
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.w800)),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            for (int i = 0; i < 7; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.blueAccent.withAlpha(10),
                    borderRadius: BorderRadius.circular(9)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          width: 130,
                          child: Image.asset(
                            "assets/medias/airpods.jpg",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nom article",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700)),
                            itemValue(
                                label: "Prix :", value: "1500", type: 'number'),
                            itemValue(
                                label: "Vendeur :",
                                value: "GuiraShop",
                                type: 'text'),
                            itemValue(
                                label: "Destination :",
                                value: "Dokui",
                                type: 'text'),
                            itemValue(
                                label: "Livraison :",
                                value: "En cours de livraison",
                                type: 'text',
                                style: 2),
                          ],
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

  Container itemValue(
      {required String label,
      required String value,
      String? type,
      int? style}) {
    return Container(
      child: Row(
        children: [
          Text(label,
              style: GoogleFonts.roboto(
                  fontSize: 12, fontWeight: FontWeight.w400)),
          SizedBox(
              width: 90,
              child: Text(
                type == 'number'
                    ? NumberFormat.currency(
                            decimalDigits: 0, symbol: 'CFA', locale: 'fr')
                        .format(double.parse(value))
                    : value,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: style == 2
                        ? const Color.fromARGB(255, 35, 90, 37)
                        : Colors.black),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
