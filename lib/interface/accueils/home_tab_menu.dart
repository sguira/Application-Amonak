import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home2.dart';
import 'package:application_amonak/interface/contact/contact.dart';
// import 'package:application_amonak/interface/contact/.dart';
import 'package:application_amonak/interface/explorer/explorer.dart';
import 'package:application_amonak/interface/nouveau/new.dart';
import 'package:application_amonak/interface/profile/profile.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageTab extends StatefulWidget {
  const HomePageTab({super.key});

  @override
  State<HomePageTab> createState() => _HomeState();
}

class _HomeState extends State<HomePageTab> {
  int currentIndex = 0;

  double iconSize = 24;

  late Notificationsocket notificationsocket;

  dynamic widgets = [
    const PublicationList(),
    const ExplorerPage(),
    const NewPage(),
    const Contact(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();

    notificationsocket = Notificationsocket();

    notificationsocket.socket!.on("refreshNotificationBoxHandler", (handler) {
      if (handler['to'] == DataController.user!.id) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: IndexedStack(index: currentIndex, children: widgets),
          bottomNavigationBar: _buildModernBottomBar()),
    );
  }

  Widget _buildModernBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(
              'Accueil', Icons.home_rounded, Icons.home_outlined, 0),
          _buildNavBarItem(
              'Explorer', Icons.search_rounded, Icons.search_outlined, 1),
          _buildAddItem(2),
          _buildNavBarItem('Discussions', Icons.chat_bubble_rounded,
              Icons.chat_bubble_outline_rounded, 3),
          _buildNavBarItem(
              'Profil', Icons.person_rounded, Icons.person_outline_rounded, 4),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
      String label, IconData activeIcon, IconData inactiveIcon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            currentIndex == index ? activeIcon : inactiveIcon,
            size: iconSize,
            color: currentIndex == index
                ? couleurPrincipale
                : Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: currentIndex == index
                  ? couleurPrincipale
                  : Colors.grey.shade600,
              fontWeight:
                  currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: currentIndex == index ? couleurPrincipale : Colors.white,
          shape: BoxShape.circle,
          boxShadow: currentIndex == index
              ? [
                  BoxShadow(
                    color: couleurPrincipale.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Icon(
          Icons.add_rounded,
          size: iconSize + 8, // Make the add icon larger
          color: currentIndex == index ? Colors.white : couleurPrincipale,
        ),
      ),
    );
  }
}
