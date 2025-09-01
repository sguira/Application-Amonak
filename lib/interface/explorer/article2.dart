import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/notifier/ArticleNotifier.dart';
import 'package:application_amonak/services/socket/publication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/widgets/wait_widget.dart';

import 'package:application_amonak/widgets/publication_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlePage2 extends ConsumerStatefulWidget {
  const ArticlePage2({super.key});

  @override
  ConsumerState<ArticlePage2> createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage2> {
  final ScrollController _scrollController = ScrollController();

  PublicationSocket? publicationSocket;

  @override
  void initState() {
    super.initState();
    // Charger les articles après le build pour éviter les erreurs
    Future.microtask(
        () => ref.read(articleProvider.notifier).loadArticles(refresh: true));

    // Infinite scroll
    _scrollController.addListener(() {
      final state = ref.read(articleProvider);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !state.loading &&
          state.hasMore) {
        ref.read(articleProvider.notifier).loadArticles();
      }
    });

    publicationSocket = PublicationSocket();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(articleProvider);

    return Scaffold(
      // appBar: AppBar(title: const Text("Articles")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ref.read(articleProvider).isNewArticleEvent
          ? FloatingActionButton.extended(
              elevation: 0,
              backgroundColor: Colors.transparent,
              label: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: couleurPrincipale.withAlpha(180),
                    borderRadius: BorderRadius.circular(26)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(
                      "Nouvel article",
                      style:
                          GoogleFonts.roboto(fontSize: 13, color: Colors.white),
                    )
                  ],
                ),
              ),
              onPressed: () {
                ref.read(articleProvider.notifier).loadArticles(refresh: true);
                _scrollController.animateTo(0,
                    duration: Durations.medium1, curve: Curves.decelerate);
              })
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(articleProvider.notifier).loadArticles(refresh: true);
        },
        child: state.loading && state.articles.isEmpty
            ? const WaitWidget()
            : state.error != null && state.articles.isEmpty
                ? Center(child: Text(state.error!))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: state.articles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.articles.length) {
                        // Loader en bas
                        return state.hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }

                      final ArticleModel article = state.articles[index];
                      return GestureDetector(
                          onTap: () {
                            // Navigation vers la page détail
                          },
                          child: ListArticle(articleModel: state.articles));
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
