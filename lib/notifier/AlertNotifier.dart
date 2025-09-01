import 'dart:convert';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationState {
  final bool loading;
  final List<Publication> alerte;
  final String? error;
  final int page;
  final bool hasMore;
  final bool newPubEvent;
  PublicationState({
    required this.loading,
    required this.alerte,
    this.error,
    this.page = 1,
    this.hasMore = true,
    this.newPubEvent = false,
  });

  PublicationState copyWith({
    bool? loading,
    List<Publication>? alerte,
    String? error,
    int? page,
    bool? hasMore,
    bool? newPubEvent,
  }) {
    return PublicationState(
      loading: loading ?? this.loading,
      alerte: alerte ?? this.alerte,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      newPubEvent: newPubEvent ?? this.newPubEvent,
    );
  }
}

class PublicationNotifier extends StateNotifier<PublicationState> {
  PublicationNotifier() : super(PublicationState(loading: false, alerte: []));

  Future<void> loadArticles(
      {bool refresh = false, String? type, String? userId}) async {
    if (state.loading) return;

    final nextPage = refresh ? 1 : state.page;

    try {
      state = state.copyWith(loading: true, error: null);

      final response = await PublicationService.getPublications(
          type: 'alerte', userId: userId);

      if (response.statusCode == 200) {
        final List<Publication> fetched = (jsonDecode(response.body) as List)
            .map((e) => Publication.fromJson(e))
            .toList();

        final List<Publication> publications =
            refresh ? fetched : [...state.alerte, ...fetched];

        state = state.copyWith(
          loading: false,
          alerte: publications,
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

  addPublication(Publication newPublication) {
    state = state
        .copyWith(alerte: [newPublication, ...state.alerte], newPubEvent: true);
  }

  Future<void> searchPublication({
    String? query,
    bool refresh = false,
  }) async {
    if (query == null || query.length < 3) return;
    state = state.copyWith(loading: true, error: null);
    final response = await PublicationService.getPublications(search: query);

    try {
      if (response.statusCode == 200) {
        final List<Publication> fetched = (jsonDecode(response.body) as List)
            .map((e) => Publication.fromJson(e))
            .toList();

        state = state.copyWith(
          loading: false,
          alerte: fetched,
          page: 1,
          hasMore: false,
        );
      } else {
        state = state.copyWith(
            loading: false, error: "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void hideNewPubBannier() {
    state = state.copyWith(newPubEvent: false);
  }
}

final alerteNotifier =
    StateNotifierProvider<PublicationNotifier, PublicationState>(
        (ref) => PublicationNotifier());
