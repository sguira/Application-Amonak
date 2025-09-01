import 'dart:convert';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoutiqueState {
  final bool loading;
  final List<User> boutiques;
  final String? error;
  final int page;
  final bool hasMore;

  BoutiqueState({
    required this.loading,
    required this.boutiques,
    this.error,
    this.page = 1,
    this.hasMore = true,
  });

  BoutiqueState copyWith({
    bool? loading,
    List<User>? boutiques,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return BoutiqueState(
      loading: loading ?? this.loading,
      boutiques: boutiques ?? this.boutiques,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class BoutiqueNotifier extends StateNotifier<BoutiqueState> {
  BoutiqueNotifier() : super(BoutiqueState(loading: false, boutiques: []));

  Future<void> loadBoutiques({String? search, bool refresh = false}) async {
    if (state.loading) return;

    final nextPage = refresh ? 1 : state.page;

    try {
      state = state.copyWith(loading: true, error: null);

      final response = await UserService.getBoutique(
        search: search,
      );

      if (response.statusCode == 200) {
        final List<User> fetched = (jsonDecode(response.body) as List)
            .map((e) => User.fromJson(e))
            .toList();

        final boutiques = refresh ? fetched : [...state.boutiques, ...fetched];

        state = state.copyWith(
          loading: false,
          boutiques: boutiques,
          page: nextPage + 1,
          hasMore: fetched.isNotEmpty,
          error: null,
        );
      } else {
        state = state.copyWith(
            loading: false, error: "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> searchBoutique({
    String? search,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final response = await UserService.getBoutique(
        search: search,
      );

      if (response.statusCode == 200) {
        final List<User> fetched = (jsonDecode(response.body) as List)
            .map((e) => User.fromJson(e))
            .toList();

        state = state.copyWith(
          loading: false,
          boutiques: fetched,
          page: 1,
          hasMore: fetched.isNotEmpty,
          error: null,
        );
      } else {
        state = state.copyWith(
            loading: false, error: "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final boutiqueProvider = StateNotifierProvider<BoutiqueNotifier, BoutiqueState>(
    (ref) => BoutiqueNotifier());
