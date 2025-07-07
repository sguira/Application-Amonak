// lib/providers/publication_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/publication.dart'; // Assurez-vous que ce chemin est correct

// Modèle pour l'état de la pagination des publications
class PublicationsState {
  final List<Publication> publications;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool hasMoreData;
  final String? errorMessage;
  final int currentLimit; // Pour suivre la limite actuelle pour l'API

  PublicationsState({
    required this.publications,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.errorMessage,
    this.currentLimit = 10, // Limite initiale
  });

  // Méthode copyWith pour créer un nouvel état avec des propriétés modifiées
  PublicationsState copyWith({
    List<Publication>? publications,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? hasMoreData,
    String? errorMessage,
    int? currentLimit,
  }) {
    return PublicationsState(
      publications: publications ?? this.publications,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLimit: currentLimit ?? this.currentLimit,
    );
  }
}

class PublicationsNotifier extends StateNotifier<PublicationsState> {
  final String? userId;
  final String? type;

  PublicationsNotifier({this.userId, this.type})
      : super(PublicationsState(publications: [])) {
    loadPublications(); // Charge les publications dès l'initialisation du Notifier
  }

  // Charge les publications initiales ou les rafraîchit
  Future<void> loadPublications({bool isRefresh = false}) async {
    if (state.isLoadingInitial && !isRefresh)
      return; // Évite les chargements multiples

    state = state.copyWith(
      isLoadingInitial: true,
      errorMessage: null, // Réinitialise les erreurs
      publications: isRefresh
          ? []
          : state.publications, // Vide la liste si c'est un rafraîchissement
      currentLimit: isRefresh
          ? 10
          : state.currentLimit, // Réinitialise la limite si rafraîchissement
      hasMoreData:
          true, // Suppose qu'il y a plus de données au rafraîchissement
    );

    try {
      final response = await PublicationService.getPublications(
        userId: userId,
        limite: state.currentLimit,
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedItems = jsonDecode(response.body);
        final List<Publication> newPublications = [];

        // Utiliser un Set pour stocker les IDs des publications existantes et éviter les doublons
        final Set<String> existingIds =
            state.publications.map((p) => p.id!).toSet();

        for (var item in fetchedItems) {
          if (item['type'] != null) {
            // Filtrer par type si spécifié et s'assurer que la publication n'existe pas déjà
            if ((type == null || type == item['type']) &&
                !existingIds.contains(item['_id'])) {
              Publication pub = Publication.fromJson(item);
              newPublications.add(pub);
            }
            // Gérer les publications partagées (type 'share')
            if (item['type'] == 'share' &&
                type != 'alerte' &&
                item['share'] != null &&
                !existingIds.contains(item['_id'])) {
              try {
                final sharedPubResponse =
                    await PublicationService.getPublicationById(
                        id: item['share']);
                if (sharedPubResponse.statusCode == 200) {
                  Publication pub =
                      Publication.fromJson(jsonDecode(sharedPubResponse.body));
                  pub.share = item['share'];
                  pub.userShare = User.fromJson(item['user']);
                  pub.shareDate = DateTime.parse(item['createdAt']);
                  pub.shareMessage = item['shareMessage'];
                  newPublications.add(pub);
                }
              } catch (e) {
                print("Error fetching shared publication: $e");
              }
            }
          }
        }

        state = state.copyWith(
          publications: [
            ...(isRefresh ? [] : state.publications),
            ...newPublications
          ],
          isLoadingInitial: false,
          hasMoreData: newPublications.length >=
              state.currentLimit, // Si moins que la limite, c'est la fin
        );
      } else {
        state = state.copyWith(
          isLoadingInitial: false,
          errorMessage: "Failed to load publications: ${response.statusCode}",
          hasMoreData: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingInitial: false,
        errorMessage: "Error loading publications: $e",
        hasMoreData: false,
      );
    }
  }

  // Charge plus de publications pour la pagination
  Future<void> loadMorePublications() async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    state = state.copyWith(isLoadingMore: true);

    final int newLimit = state.currentLimit + 7; // Incrément de 7 publications

    try {
      final response = await PublicationService.getPublications(
        userId: userId,
        limite: newLimit,
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedItems = jsonDecode(response.body);
        final List<Publication> newPublications = [];
        final Set<String> existingIds =
            state.publications.map((p) => p.id!).toSet();

        for (var item in fetchedItems) {
          if (item['type'] != null) {
            if ((type == null || type == item['type']) &&
                !existingIds.contains(item['_id'])) {
              Publication pub = Publication.fromJson(item);
              newPublications.add(pub);
            }
            if (item['type'] == 'share' &&
                type != 'alerte' &&
                item['share'] != null &&
                !existingIds.contains(item['_id'])) {
              try {
                final sharedPubResponse =
                    await PublicationService.getPublicationById(
                        id: item['share']);
                if (sharedPubResponse.statusCode == 200) {
                  Publication pub =
                      Publication.fromJson(jsonDecode(sharedPubResponse.body));
                  pub.share = item['share'];
                  pub.userShare = User.fromJson(item['user']);
                  pub.shareDate = DateTime.parse(item['createdAt']);
                  pub.shareMessage = item['shareMessage'];
                  newPublications.add(pub);
                }
              } catch (e) {
                print("Error fetching shared publication on load more: $e");
              }
            }
          }
        }

        state = state.copyWith(
          publications: [...state.publications, ...newPublications],
          isLoadingMore: false,
          currentLimit: newLimit,
          hasMoreData: newPublications.length ==
              (newLimit -
                  state
                      .currentLimit), // Vérifie si de nouvelles publications ont été ajoutées
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage:
              "Failed to load more publications: ${response.statusCode}",
          hasMoreData: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: "Error loading more publications: $e",
        hasMoreData: false,
      );
    }
  }

  // Méthode pour rechercher des publications (vous pouvez l'intégrer si besoin)
  Future<void> searchPublications(String query) async {
    state = state.copyWith(isLoadingInitial: true, errorMessage: null);
    try {
      final response = await PublicationService.getPublications(search: query);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedItems = jsonDecode(response.body);
        final List<Publication> searchResults =
            fetchedItems.map((item) => Publication.fromJson(item)).toList();
        state = state.copyWith(
          publications: searchResults,
          isLoadingInitial: false,
          hasMoreData: false, // Pas de pagination pour la recherche simple
        );
      } else {
        state = state.copyWith(
          isLoadingInitial: false,
          errorMessage: "Failed to search publications: ${response.statusCode}",
          publications: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingInitial: false,
        errorMessage: "Error searching publications: $e",
        publications: [],
      );
    }
  }

  // Méthode pour supprimer une publication localement et via l'API
  Future<void> deletePublication(String id) async {
    try {
      final response = await PublicationService.suppression(id);
      if (response == 200) {
        // Assuming your suppression service returns 200 on success
        state = state.copyWith(
          publications:
              state.publications.where((pub) => pub.id != id).toList(),
        );
        // Vous pouvez ajouter un message de succès ici si vous le souhaitez
      } else {
        // Gérer l'erreur de suppression
        print("Erreur lors de la suppression de la publication: $response");
      }
    } catch (e) {
      print("Erreur lors de la suppression de la publication (exception): $e");
    }
  }
}

// Fournisseur Riverpod pour PublicationsNotifier
final publicationsNotifierProvider = StateNotifierProvider.family<
    PublicationsNotifier, PublicationsState, Map<String, dynamic>?>(
  (ref, args) {
    return PublicationsNotifier(
      userId: args?['userId'] as String?,
      type: args?['type'] as String?,
    );
  },
);

// Pour les publications passées directement (si `widget.publications` n'est pas null)
final initialPublicationsProvider2 =
    Provider.family<List<Publication>, List<Publication>?>(
  (ref, publications) => publications ?? [],
);
