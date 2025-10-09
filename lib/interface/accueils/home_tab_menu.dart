import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/interface/accueils/home2.dart';
import 'package:application_amonak/interface/contact/contact.dart';
import 'package:application_amonak/interface/contact/contactWithNotifier.dart';
import 'package:application_amonak/interface/explorer/explorer.dart';
import 'package:application_amonak/interface/nouveau/new.dart';
import 'package:application_amonak/interface/profile/profile.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/notifier/AlertNotifier.dart';
import 'package:application_amonak/notifier/ArticleNotifier.dart';
import 'package:application_amonak/notifier/NotificationNotifier.dart';
import 'package:application_amonak/notifier/PublicationNotifierFianl.dart';
import 'package:application_amonak/services/notificationService.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/services/socket/commentSocket.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageTab extends ConsumerStatefulWidget {
  const HomePageTab({super.key});

  @override
  ConsumerState<HomePageTab> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePageTab> {
  int currentIndex = 0;

  double iconSize = 24;

  late Notificationsocket notificationsocket;
  late PublicationSocket publicationSocket;
  late Commentsocket commentSocket;
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
    publicationSocket = PublicationSocket();
    commentSocket = Commentsocket();
    MessageSocket messageSocket = MessageSocket();
    //reception des notifications
    notificationsocket.socket!.on("refreshNotificationBoxHandler", (handler) {
      print("notification recu $handler \n\\n\n");
      if (handler['to'] == DataController.user!.id) {
        NotificationModel notif = NotificationModel.fromJson(handler);
        ref.read(notificationProdider.notifier).addNotification(notif);
        ref.read(notificationProdider.notifier).loadNotification();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(notif.content!),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Voir',
            onPressed: () {},
          ),
        ));
      }
    });

    //reception de nouvelle publications
    publicationSocket.socket!.on('newPublicationListener', (handler) {
      print("Socket de nouvelle publication déclenché :$handler ok");

      if (handler['type'] == 'default' ||
          handler['type'] == null ||
          handler['type'] == 'publication') {
        Publication pub = Publication.fromJson(handler);
        ref.read(publicationProvider22.notifier).addPublication(pub);

        if (DataController.friends
            .where((x) => x.id == handler['user']['id'])
            .isNotEmpty) {
          NotificationLocalService.showNotification(
              title: "Vient de publier un article", body: handler['content']);
        }
      }
      if (handler['type'] == 'seller') {
        ArticleModel? articleModel = ArticleModel.fromJson(handler);
        ref.read(articleProvider.notifier).addArticle(articleModel!);
      }
      if (handler['type'] == 'alerte') {
        Publication pub = Publication.fromJson(handler);
        ref.read(alerteNotifier.notifier).addAlerte(pub);
      }
    });

    // Socket des commentaires
    commentSocket.socket!.on("newCommentEventListener", (data) {
      print("Nouveau Commentaire détecté !!! $data");
      if (data['user']['_id'] == DataController.user!.id) {
        NotificationLocalService.showNotification(
            title: "Commentaire",
            body: "Votre publication vient de recevoir un nouveau commentaire");
      }
    });

    // MessageSocket
    messageSocket.socket!.on("refreshMessageBoxHandler", (handler) {
      if (handler['to'] == DataController.user!.id) {
        NotificationLocalService.showNotification(
            title: "Message",
            body: "Vous avez réçu un message",
            payload: jsonEncode({"route": "message", "id": handler['from']}));
      }
    });

    Future.microtask(
        () => ref.read(notificationProdider.notifier).loadNotification());
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

        Future.microtask(
            () => ref.read(publicationProvider22.notifier).setMemory(false));
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
