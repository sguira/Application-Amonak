import 'dart:convert';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/prod.dart';
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
  final List<Publication> newPub;
  PublicationState({
    required this.loading,
    required this.alerte,
    this.error,
    this.page = 1,
    this.hasMore = true,
    this.newPubEvent = false,
    this.newPub = const [],
  });

  PublicationState copyWith({
    bool? loading,
    List<Publication>? alerte,
    String? error,
    int? page,
    bool? hasMore,
    bool? newPubEvent,
    List<Publication>? newPub,
  }) {
    return PublicationState(
      loading: loading ?? this.loading,
      alerte: alerte ?? this.alerte,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      newPubEvent: newPubEvent ?? this.newPubEvent,
      newPub: newPub ?? this.newPub,
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
        final List<Publication> fetched = [];

        for (var item in jsonDecode(response.body)) {
          Publication pub = Publication.fromJson(item);
          if (pub.user != null) {
            fetched.add(pub);
          }
        }
        state = state.copyWith(
          loading: false,
          alerte: fetched,
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

  addAlerte(Publication newPublication) {
    var condition = state.alerte.map((e) => e.id == newPublication.id).isEmpty;
    if (condition) {
      state = state.copyWith(
          newPub: [newPublication, ...state.alerte],
          newPubEvent: state.alerte.length > newElementNoticeLimit);
    }
  }

  fusionAlerte() {
    if (state.newPub.isNotEmpty) {
      state = state.copyWith(alerte: [...state.newPub, ...state.alerte]);
    }
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
        final List<Publication> fetched = [];

        for (var item in jsonDecode(response.body)) {
          Publication pub = Publication.fromJson(item);
          if (pub.user != null) {
            fetched.add(pub);
          }
        }

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

  void deletePublication(String id) {
    state =
        state.copyWith(alerte: state.alerte.where((p) => p.id != id).toList());
  }
}

final alerteNotifier =
    StateNotifierProvider<PublicationNotifier, PublicationState>(
        (ref) => PublicationNotifier());
