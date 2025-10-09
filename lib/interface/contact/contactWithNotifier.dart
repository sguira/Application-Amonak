import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/contact/message.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:application_amonak/notifier/MessageNotifier.dart';

class ContactWithNotifier extends ConsumerStatefulWidget {
  const ContactWithNotifier({super.key});

  @override
  ConsumerState<ContactWithNotifier> createState() => _ContactState();
}

class _ContactState extends ConsumerState<ContactWithNotifier> {
  late MessageSocket socket;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(messageProvider.notifier).loadMessage(refresh: true);
    });

    socket = MessageSocket();

    socket.socket!.on("refreshMessageBoxHandler", (handler) {
      print("Nouveau Message ... $handler");
      if (handler['to'] == DataController.user!.id) {
        // loadMessage();
      }
    });
  }

  @override
  void dispose() {
    socket.socket!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      ref.read(messageProvider.notifier).loadMessage(refresh: false);
    });
    final state = ref.watch(messageProvider);

    return Scaffold(
      backgroundColor: backgroundColors,
      body: Container(
        margin: const EdgeInsets.all(12),
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discussions".toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const ButtonNotificationWidget()
                ],
              ),
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Rechercher un contact",
                  hintStyle: GoogleFonts.roboto(
                      fontSize: 14, color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            if (state.isLoad == true && state.hasError == null)
              const WaitWidget(),
            if (state.hasError != null && state.isLoad == false)
              Text(state.hasError.toString()),
            if (state.hasError == null && state.isLoad == false)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                child: state.messages.isNotEmpty
                    ? Container(
                        child: Column(
                          children: [
                            for (MessageModel item in state.messages)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MessagePage(
                                              user: item.iSend
                                                  ? item.to
                                                  : item.from)));
                                },
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 76),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 0),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              // margin: ,
                                              padding: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(36),
                                                  border: Border.all(
                                                      width: .5,
                                                      color:
                                                          couleurPrincipale)),
                                              width: 42,
                                              height: 42,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                                child: item.to.avatar!.isEmpty
                                                    ? Image.asset(
                                                        "assets/medias/profile.jpg",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        item.to.avatar!.first
                                                            .url!,
                                                        fit: BoxFit.fitHeight,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                            "assets/medias/profile.jpg",
                                                            fit: BoxFit.cover,
                                                            width: 48,
                                                            height: 48,
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      ScreenSize.width * 0.6),
                                              margin: const EdgeInsets.only(
                                                  left: 6),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      item.iSend == true
                                                          ? item.to.userName!
                                                          : item.from.userName,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Row(
                                                    children: [
                                                      // Icon(FontAwesomeIcons.checkDouble,size: 16,),
                                                      Flexible(
                                                        child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              // maxWidth:
                                                              //     200,
                                                              maxHeight: 58,
                                                              maxWidth: 300,
                                                            ),
                                                            child: Text(
                                                                item.content,
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                        fontSize:
                                                                            12))),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 36),
                        child: Text(
                          "Aucun message envoyé pour le moment.",
                          style: GoogleFonts.roboto(),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
