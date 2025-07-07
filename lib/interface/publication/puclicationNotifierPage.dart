// lib/interface/publication/publication_page.dart (ou l'emplacement original)
import 'dart:convert';
import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart'; // Assurez les imports sont corrects
import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/interface/publication/image_container.dart';
import 'package:application_amonak/interface/publication/videoPlayerWidget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/notifier/NotificationNotifier2.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/header_publication.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/text_expanded.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:application_amonak/widgets/zone_commentaire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Changer StatefulWidget en ConsumerStatefulWidget
class PublicationPage2 extends ConsumerStatefulWidget {
  final String? type;
  final String? userId;
  final bool? hideLabel;
  final List<Publication>?
      publications; // Pour les publications initiales si passées

  const PublicationPage2({
    super.key,
    this.type,
    this.userId,
    this.hideLabel,
    this.publications,
  });

  @override
  ConsumerState<PublicationPage2> createState() => _PublicationPageState();
}

// Changer State en ConsumerState
class _PublicationPageState extends ConsumerState<PublicationPage2> {
  // Supprimez les variables d'état locales pour les publications et le chargement
  // List<Publication> publication = [];
  // late Future<dynamic> loadDataResult;
  // bool _isLoadingMore = false;
  // bool _hasMoreData = true;

  late int nbLike =
      0; // Peut rester si utilisé localement pour un élément spécifique
  late bool isLiked = false; // Peut rester
  TextEditingController search = TextEditingController();
  String type = '';

  late PublicationSocket publicationSocket;
  late Notificationsocket notificationsocket;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    publicationSocket = PublicationSocket();
    notificationsocket = Notificationsocket();

    publicationSocket.socket!.on("likePublicationListener", (handler) {
      print("La publication a été liké");
      // Si vous voulez mettre à jour un like spécifique via socket,
      // vous devrez trouver la publication dans l'état de Riverpod et la mettre à jour.
      // Cela peut être fait en appelant une méthode sur le Notifier.
    });
    publicationSocket.socket!.on("newPublicationListener", (handler) {
      // Lorsqu'une nouvelle publication arrive, rafraîchir la liste via Riverpod
      if (mounted) {
        ref
            .read(publicationsNotifierProvider({
              'userId': widget.userId,
              'type': widget.type,
            }).notifier)
            .loadPublications(isRefresh: true);
      }
    });
    notificationsocket.socket!.on("refreshNotificationBoxHandler", (handler) {
      print("Une nouvelle notification < $handler \n\n\n");
      // Ici, vous pourriez déclencher un rafraîchissement du compteur de notifications
      // en utilisant un provider Riverpod pour les notifications.
    });

    // Attacher le listener pour le défilement
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Demander au notifier de charger plus de données
        ref
            .read(publicationsNotifierProvider({
              'userId': widget.userId,
              'type': widget.type,
            }).notifier)
            .loadMorePublications();
      }
    });
  }

  @override
  void dispose() {
    publicationSocket.socket!.close();
    _scrollController.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Écouter l'état des publications via Riverpod
    final publicationsState = widget.publications != null
        ? ref.watch(initialPublicationsProvider2(widget.publications))
        : ref.watch(publicationsNotifierProvider(
            {'userId': widget.userId, 'type': widget.type}));

    return Column(
      children: [
        // Le header est indépendant des publications, il peut rester tel quel
        header((_) {
          // setState_ du StatefulBuilder précédent n'est plus nécessaire ici
          // Si vous voulez une réaction, vous devrez probablement utiliser ref.read
          // pour appeler une méthode sur le notifier (ex: searchPublications)
        }),
        Expanded(
          child: Builder(
            // Utiliser Builder pour avoir un contexte qui peut rebuild
            builder: (context) {
              // Vérifier si des publications initiales sont passées
              if (widget.publications != null) {
                if ((publicationsState as List).isEmpty) {
                  return const AucunElement(label: "Aucune publication");
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: (publicationsState as List).length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final Publication pub = (publicationsState as List)[index];
                    return buildPublicationItem(pub);
                  },
                );
              }

              // Si les publications sont gérées par PublicationsNotifier
              if (publicationsState is PublicationsState) {
                if (publicationsState.isLoadingInitial &&
                    publicationsState.publications.isEmpty) {
                  return const WaitWidget();
                }
                if (publicationsState.errorMessage != null &&
                    publicationsState.publications.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 22),
                    child: Center(
                        child:
                            Text('Erreur: ${publicationsState.errorMessage}')),
                  );
                }
                if (publicationsState.publications.isEmpty) {
                  return const AucunElement(label: "Aucune publication");
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: publicationsState.publications.length +
                      (publicationsState.isLoadingMore ? 1 : 0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index < publicationsState.publications.length) {
                      final Publication pub =
                          publicationsState.publications[index];
                      return buildPublicationItem(pub);
                    } else {
                      // Indicateur de chargement pour la pagination
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              }
              // Fallback si l'état n'est ni liste ni PublicationsState (ne devrait pas arriver avec les familles de providers bien définies)
              return const Text(
                  'Erreur inattendue de l\'état des publications.');
            },
          ),
        ),
      ],
    );
  }

  // Méthode réutilisable pour construire un élément de publication
  Widget buildPublicationItem(Publication pub) {
    return pub.share == null
        ? ItemPublication(
            pub: pub,
            type: widget.type,
            publicationSocket: publicationSocket,
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                HeaderPublication(
                  style: 1,
                  dateCreation: pub.shareDate!,
                  context: context,
                  user: pub.userShare!,
                ),
                TextExpanded(texte: pub.shareMessage!),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ItemPublication(
                    pub: pub,
                    publicationSocket: publicationSocket,
                  ),
                ),
              ],
            ),
          );
  }

  // Reste de votre code (bodyContainer, textContainer, imageContaint, etc.)
  // Ces méthodes peuvent rester des membres de la classe _PublicationPageState
  // car elles sont utilisées par le widget lui-même pour construire l'UI des publications.
  // Elles n'ont pas besoin d'accéder directement à Riverpod pour leur logique interne.

  Container bodyContainer(Publication item) {
    return Container(
      child: Column(
        children: [
          textContainer(item.content!),
          if (item.files.isNotEmpty && item.files[0].url != '')
            item.files[0].type == 'image'
                ? imageContaint(item.files[0].url)
                : VideoPlayerWidget2(url: item.files[0].url!)
        ],
      ),
    );
  }

  Container textContainer(String texte) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: MediaQuery.of(context).size.width *
          0.8, // Utilisez MediaQuery pour la taille de l'écran
      constraints: const BoxConstraints(maxHeight: 80),
      child: Text(
        texte,
        textAlign: TextAlign.start,
        style: GoogleFonts.roboto(fontSize: 12),
        overflow: TextOverflow.fade,
      ),
    );
  }

  Container imageContaint(String? image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: image != null && image.isNotEmpty
            ? Image.network(
                image,
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
              ),
      ),
    );
  }

  // Attention: footerContainer n'est pas utilisé dans le code modifié si ItemPublication gère déjà le footer.
  // Vous devrez l'intégrer dans ItemPublication ou PublicationCard si c'est là qu'il est censé apparaître.
  Container footerContainer(Publication publication) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              itemDescription("100", "Likes"),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // Permet au BottomSheet de prendre plus de hauteur
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor:
                              0.8, // Prend 80% de la hauteur de l'écran
                          child: CommentaireWidget(
                              pubId: publication.id, pub: publication),
                        );
                      });
                },
                child: itemDescription("5000", "Commentaires"),
              ),
              itemDescription("10000", "Partages"),
            ],
          ),
          Row(
            children: [
              buttonIcon(Icons.favorite_border),
              buttonIcon(Icons.comment),
              buttonIcon(Icons.repeat)
            ],
          )
        ],
      ),
    );
  }

  Widget header(void Function(void Function()) setState_) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.hideLabel != true)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                "\" NOUS DEVENONS CE QUE NOUS PENSONS \"",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          Container(
            width: 280,
            height: 42,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                hintText: 'Chercher..',
                hintStyle: GoogleFonts.roboto(fontSize: 12),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide:
                      const BorderSide(width: 0, color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide:
                      const BorderSide(width: 0, color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                if (value.length >= 3) {
                  ref
                      .read(publicationsNotifierProvider({
                        'userId': widget.userId,
                        'type': widget.type,
                      }).notifier)
                      .searchPublications(value);
                } else if (value.isEmpty) {
                  // Si la recherche est vide, recharger les publications normales
                  ref
                      .read(publicationsNotifierProvider({
                        'userId': widget.userId,
                        'type': widget.type,
                      }).notifier)
                      .loadPublications(isRefresh: true);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Container buttonIcon(IconData icon) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: Icon(
          icon,
          size: 28,
        ),
      );

  Widget itemDescription(String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Text(
            NumberFormat.compact(locale: 'fr').format(int.parse(value)),
            style:
                GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(width: 2),
          SizedBox(
            width: 32,
            child: Text(
              label,
              style: GoogleFonts.roboto(fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  // Gardez les autres méthodes auxiliaires ici si elles sont utilisées
  // (alerteSuppression, headerBoutique, etc.)
  alerteSuppression(String id) {
    Navigator.pop(context);
    bool wait = false;
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState_) {
              return AlertDialog(
                title: Text("Confirmer la suppression",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: Container(
                  child: Text(
                    "Cette action aura pour conséquence la suppression de la publication",
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Annuler')),
                  TextButton(
                      onPressed: () async {
                        setState_(() {
                          wait = true;
                        });
                        // Appel à la méthode de suppression du Notifier Riverpod
                        await ref
                            .read(publicationsNotifierProvider({
                              'userId': widget.userId,
                              'type': widget.type
                            }).notifier)
                            .deletePublication(id);
                        setState_(() {
                          wait = false;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('La publication a été supprimée!')),
                        );
                      },
                      child: wait == false
                          ? const Text('Confirmer')
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: const CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            ))
                ],
              );
            }));
  }
}

class AucunElement extends StatelessWidget {
  final String label;
  const AucunElement({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: couleurPrincipale.withAlpha(80)),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                label,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
  }
}
