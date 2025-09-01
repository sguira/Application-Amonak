import 'dart:convert';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/services/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleState {
  final bool loading;
  final List<ArticleModel> articles;
  final String? error;
  final int page;
  final bool hasMore;
  final bool isNewArticleEvent;
  ArticleState(
      {required this.loading,
      required this.articles,
      this.error,
      this.page = 1,
      this.hasMore = true,
      this.isNewArticleEvent = false});

  ArticleState copyWith(
      {bool? loading,
      List<ArticleModel>? articles,
      String? error,
      int? page,
      bool? hasMore,
      bool? isNewArticleEvent}) {
    return ArticleState(
        loading: loading ?? this.loading,
        articles: articles ?? this.articles,
        error: error,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isNewArticleEvent: isNewArticleEvent ?? this.isNewArticleEvent);
  }
}

class ArticleNotifier extends StateNotifier<ArticleState> {
  ArticleNotifier() : super(ArticleState(loading: false, articles: []));

  Future<void> loadArticles({bool refresh = false}) async {
    if (state.loading) return;

    final nextPage = refresh ? 1 : state.page;

    try {
      state = state.copyWith(loading: true, error: null);

      final response = await ProductService.getSingleArticle();

      if (response.statusCode == 200) {
        final List<ArticleModel> fetched = (jsonDecode(response.body) as List)
            .map((e) => ArticleModel.fromJson(e)!)
            .toList();

        final List<ArticleModel> articles =
            refresh ? fetched : [...state.articles, ...fetched];

        state = state.copyWith(
          loading: false,
          articles: articles,
          page: nextPage + 1,
          hasMore: fetched.isNotEmpty,
        );
      } else {
        state = state.copyWith(
            loading: false, error: "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void addArticle(ArticleModel article) {
    state = state.copyWith(
        isNewArticleEvent: true, articles: [article, ...state.articles]);
  }
}

final articleProvider = StateNotifierProvider<ArticleNotifier, ArticleState>(
    (ref) => ArticleNotifier());
