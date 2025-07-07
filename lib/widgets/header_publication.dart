import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderPublication extends StatefulWidget {
  const HeaderPublication(
      {super.key,
      required this.style,
      required this.dateCreation,
      required this.context,
      this.typeLateralBtn,
      required this.user});

  final User user;
  final int style;
  final DateTime dateCreation;
  final BuildContext context;
  final String? typeLateralBtn;

  @override
  State<HeaderPublication> createState() => _HeaderPublicationState();
}

class _HeaderPublicationState extends State<HeaderPublication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(86),
                // color: Colors.black12
              ),
              child: ClipOval(
                  child: widget.user.avatar!.isEmpty
                      ? Image.asset(
                          'assets/medias/profile.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.user.avatar!.first.url!,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/medias/profile.jpg",
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            );
                          },
                        ))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.userName!,
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Publié il y'a ${DataController.FormatDate(date: widget.dateCreation)}",
                  style: GoogleFonts.roboto(
                      fontSize: 13, fontStyle: FontStyle.italic),
                ),
                // style!=1?
                // Text("1",style: GoogleFonts.roboto(fontSize: 11),):Container(),
              ],
            ),
          ),
          const Spacer(),
          if (widget.typeLateralBtn != null && widget.typeLateralBtn == "close")
            Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  )),
            ),
          if (widget.typeLateralBtn == null || widget.typeLateralBtn == '')
            Container(
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            )
        ],
      ),
    );
  }
}
