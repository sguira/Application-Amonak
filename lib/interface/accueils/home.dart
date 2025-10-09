import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart';
import 'package:application_amonak/notifier/PublicationNotifierFianl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:application_amonak/models/publication.dart';

import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController pageController = PageController();
  int? currentPage;

  @override
  void initState() {
    super.initState();
    // Charger les publications via Riverpod
    // Future.microtask(
    //     () => ref.read(publicationProvider22.notifier).loadArticles());
    // Future.microtask(
    //     () => ref.read(notificationProdider.notifier).loadNotification());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicationProvider22);

    if (state.loading && state.publication.isEmpty) {
      return const WaitWidget();
    }

    if (state.error != null && state.publication.isEmpty) {
      return Center(child: Text(state.error!));
    }

    return state.publication.isNotEmpty
        ? VideoScrollWidget(publications: state.publication)
        : const Center(child: Text("Aucune publication"));
  }
}

class VideoScrollWidget extends ConsumerStatefulWidget {
  final List<Publication>? publications;
  const VideoScrollWidget({super.key, this.publications});

  @override
  ConsumerState<VideoScrollWidget> createState() => _VideoScrollWidgetState();
}

class _VideoScrollWidgetState extends ConsumerState<VideoScrollWidget> {
  PageController pageController = PageController();
  int? currentPage;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicationProvider22);
    // final publications =
    //     state.publication.where((p) => p.type != 'share').toList();

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      physics: const CustomScrollPhysics(sensitivity: 0.4),
      itemCount: state.publication.length,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        // if (state.publication[index].type == 'share') return const SizedBox();
        final pub = state.publication[index];
        print("Publication type: ${pub.typePub} \n\n\n\n ");
        return Scaffold(
          body: VideoPlayerWidget(
            videoItem: pub,
            index: index,
            isCurrentPage: currentPage == index,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.newPubEvent
              ? FloatingActionButton.extended(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  // isExtended: true,

                  onPressed: () {
                    ref.read(publicationProvider22.notifier).state =
                        state.copyWith(newPubEvent: false);
                    currentPage = 0;
                    ref
                        .read(publicationProvider22.notifier)
                        .loadArticles(refresh: true);
                    pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  label: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: couleurPrincipale.withAlpha(180),
                        borderRadius: BorderRadius.circular(26)),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.white),
                        Text(
                          "Nouvelle publication",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ))
              : null,
        );
      },
    );
  }

  Widget ButtonNewPubEvent(BuildContext context, PublicationState state) {
    return Container(
      // height: 42,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: couleurPrincipale.withAlpha(120),
        borderRadius: BorderRadius.circular(38),
      ),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            "Nouvelle publication",
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final double sensitivity;

  const CustomScrollPhysics({ScrollPhysics? parent, this.sensitivity = 1.0})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
        parent: buildParent(ancestor), sensitivity: sensitivity);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Divise l'offset par la sensibilité
    return super.applyPhysicsToUserOffset(position, offset / sensitivity);
  }
}
