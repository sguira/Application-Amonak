import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/notifier/personneNotifier.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowUserWidget extends ConsumerWidget {
  User user;
  FollowUserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(personneNotifier);

    bool isFriend(User user) {
      for (var u in state.friends!) {
        if (u.id == user.id) {
          return true;
        }
      }
      return false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsUser(user: user)));
            },
            child: Container(
              width: 68,
              height: 68,
              // padding:const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(86),
                  color: Colors.black12),
              child: ClipOval(
                  child: user.avatar!.isNotEmpty
                      ? Image.network(
                          user.avatar![0].url!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/medias/profile.jpg",
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/medias/user.jpg",
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Container(
              alignment: Alignment.center,
              width: 90,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                user.userName.toString().toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2),
                overflow: TextOverflow.ellipsis,
              )),
          !isFriend(user)
              ? TextButton(
                  onPressed: () {
                    UserService.sendFriend(user.id!).then((value) {
                      print('Friend request sent $value');
                      if (value == 'OK') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invitaion envoyée ")));
                        // DataController.
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Erreur lors de")));
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: couleurPrincipale.withAlpha(40),
                      padding: const EdgeInsets.symmetric(horizontal: 18)),
                  child: Text("S'abonner",
                      style: GoogleFonts.roboto(fontSize: 11)))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                      // color: Colors.black12,
                      borderRadius: BorderRadius.circular(22)),
                  child: Wrap(
                    children: [
                      const Icon(
                        Icons.check,
                        size: 18,
                      ),
                      Text(
                        "Abonné",
                        style: GoogleFonts.roboto(fontSize: 13),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
