import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/explorer/ExplorerSearchWidget.dart';
import 'package:application_amonak/interface/publication/image_container.dart';
import 'package:application_amonak/notifier/PublicationNotifierFianl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/widgets/publication_card.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicationPageRiverPod extends ConsumerStatefulWidget {
  final String? type;
  final String? userId;
  final bool? hideLabel;

  const PublicationPageRiverPod(
      {super.key, this.type, this.userId, this.hideLabel});

  @override
  ConsumerState<PublicationPageRiverPod> createState() =>
      _PublicationPageState();
}

class _PublicationPageState extends ConsumerState<PublicationPageRiverPod> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // // Charger les publications après le build
    // Future.microtask(() =>
    //     ref.read(publicationProvider22.notifier).loadArticles(refresh: false));

    // Pagination
    _scrollController.addListener(() {
      final state = ref.read(publicationProvider22);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !state.loading &&
          state.hasMore) {
        ref.read(publicationProvider22.notifier).loadArticles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicationProvider22);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: state.newPubEvent == true
          ? FloatingActionButton.extended(
              backgroundColor: Colors.transparent,
              hoverColor: Colors.transparent,
              elevation: 0,
              label: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: couleurPrincipale.withAlpha(160),
                    borderRadius: BorderRadius.circular(26)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(
                      "Nouvelle publication",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () {
                ref
                    .read(publicationProvider22.notifier)
                    .loadArticles(refresh: true);
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
                ref.read(publicationProvider22.notifier).hideNewPubBannier();
              })
          : null,
      body: Column(
        children: [
          if (widget.hideLabel != true)
            ExplorerSearchWidget(
              onSearchChanged: searchData,
              searchController: searchController,
            ),
          Expanded(
            child: state.loading && state.publication.isEmpty
                ? const WaitWidget()
                : state.error != null && state.publication.isEmpty
                    ? Center(child: Text(state.error!))
                    : RefreshIndicator(
                        onRefresh: () => ref
                            .read(publicationProvider22.notifier)
                            .loadArticles(refresh: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.publication.length + 1,
                          itemBuilder: (context, index) {
                            if (index == state.publication.length) {
                              return state.hasMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            }

                            final Publication pub = state.publication[index];
                            return ItemPublication(
                              pub: pub,
                              type: widget.type,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void searchData(String value) {
    if (value.length >= 3) {
      ref
          .read(publicationProvider22.notifier)
          .searchPublication(query: searchController.text);
    } else {
      ref.read(publicationProvider22.notifier).loadArticles(refresh: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
