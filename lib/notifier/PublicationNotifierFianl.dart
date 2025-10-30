import 'dart:convert';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationState {
  final bool loading;
  final List<Publication> publication;
  final List<Publication> newPub;
  final List<Publication> myPublication;
  final String? error;
  final int page;
  final bool hasMore;
  final bool newPubEvent;
  final bool isMemory;
  PublicationState(
      {required this.loading,
      required this.publication,
      this.error,
      this.page = 1,
      this.hasMore = true,
      this.newPubEvent = false,
      this.newPub = const [],
      this.isMemory = true,
      this.myPublication = const []});

  PublicationState copyWith(
      {bool? loading,
      List<Publication>? publication,
      String? error,
      int? page,
      bool? hasMore,
      bool? newPubEvent,
      List<Publication>? newPub,
      bool? isMemory}) {
    return PublicationState(
        loading: loading ?? this.loading,
        publication: publication ?? this.publication,
        error: error,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        newPubEvent: newPubEvent ?? this.newPubEvent,
        newPub: newPub ?? this.newPub,
        isMemory: isMemory ?? this.isMemory,
        myPublication: myPublication ?? this.myPublication);
  }
}

class PublicationNotifier extends StateNotifier<PublicationState> {
  PublicationNotifier()
      : super(PublicationState(
            loading: false,
            publication: [],
            newPub: [],
            newPubEvent: false,
            isMemory: false,
            myPublication: []));

  Future<void> loadArticles(
      {bool refresh = false,
      String? type,
      String? userId,
      String? search}) async {
    if (state.loading && refresh == false) return;

    final nextPage = refresh ? 1 : state.page;

    try {
      state = state.copyWith(loading: true, error: null);

      final response =
          await PublicationService.getPublications(type: type, userId: userId);

      if (response.statusCode == 200) {
        state = state.copyWith(publication: []);
        List<Publication> fetched = [];
        for (var item in jsonDecode(response.body)) {
          try {
            if (item['type'] != null) {
              if (item['type'] == 'share') {
                print("Une publication de type: ${item['type']}\n\n\n");
                try {
                  PublicationService.getPublicationById(id: item['share'])
                      .then((res) {
                    if (res.statusCode == 200) {
                      print("PUB DETER ${res.body} \n\n\n ");
                      final pubShared =
                          Publication.fromJson(jsonDecode(res.body));
                      pubShared.share = item['share'];
                      pubShared.userShare = User.fromJson(item['user']);
                      pubShared.shareDate = DateTime.parse(item['createdAt']);
                      pubShared.shareMessage = item['shareMessage'] ?? "";
                      if (pubShared.typePub != null) {
                        fetched.add(pubShared);
                      }
                      // fetched = [...fetched, pubShared];
                    }
                  });
                } catch (e) {
                  print("Une erreur est survenue ssee");
                }
              } else {
                // fetched = [...fetched, ];
                final ele = Publication.fromJson(item);
                if (ele.type != null) {
                  fetched.add(ele);
                }
                // fetched.add();
              }
            }
          } catch (e) {
            print("Une erreur est survenue ssee");
          }
        }

        final List<Publication> publications =
            refresh ? fetched : [...state.publication, ...fetched];

        state = state.copyWith(
          loading: false,
          publication: publications,
          page: nextPage + 1,
          hasMore: fetched.isNotEmpty,
        );
      } else {
        state = state.copyWith(
            loading: false, error: "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      print('Une error irreversible;;;');
    }
  }

  getByFilter({
    required String type,
  }) {
    return state.publication.where((pub) => pub.type == type).toList();
  }

  setMemory(bool value) {
    state = state.copyWith(isMemory: value);
  }

  addPublication(Publication newPublication) {
    var pub = state.newPub;
    var condition =
        pub.map((toElement) => toElement.id == newPublication.id).isEmpty;
    if (condition) {
      state = state.copyWith(newPub: [newPublication, ...state.newPub]);
      print("Taille de newPub: ${state.newPub.length} \n\n\n\n");
      state = state.copyWith(
          newPubEvent:
              state.newPub.length >= newElementNoticeLimit ? true : false);
      print("Nouvelle publication ajoutée dans le state local: \n\n\n\n");
    }
  }

  fusionPub() {
    // if (state.newPub.isEmpty) return;
    state = state.copyWith(
        publication: [...state.newPub, ...state.publication],
        newPub: [],
        newPubEvent: false);
  }

  void deletePublication(String id) {
    state = state.copyWith(
        publication: state.publication.where((p) => p.id != id).toList());
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
          publication: fetched,
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

final publicationProvider22 =
    StateNotifierProvider<PublicationNotifier, PublicationState>(
        (ref) => PublicationNotifier());
