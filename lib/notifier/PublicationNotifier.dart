import 'dart:convert';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/publication.dart'; // Assurez-vous que ce chemin est correct
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Définissez votre notifier
class PublicationNotifier extends AsyncNotifier<List<Publication>> {
  // La méthode `build` est l'endroit où vous initialisez l'état asynchrone.
  // Elle est appelée une seule fois au premier accès au provider.
  @override
  Future<List<Publication>> build() async {
    return _fetchPublications();
  }

  // Méthode privée pour la logique de récupération des publications.
  // Ne modifiez pas directement `state` ici, laissez `build` gérer le premier chargement.
  // Pour les rechargements ultérieurs, utilisez `ref.invalidate` ou mettez à jour `state` directement.
  Future<List<Publication>> _fetchPublications() async {
    try {
      final response = await PublicationService.getPublications();
      if (response.statusCode == 200) {
        List<Publication> publications = [];
        for (var pubJson in jsonDecode(response.body)) {
          // Ajoutez une vérification plus robuste avant d'ajouter
          // Si 'files' est un champ requis, assurez-vous qu'il est présent et non vide.
          // Si 'files' peut être absent, adaptez votre modèle Publication en conséquence.
          if (pubJson['files'] != null &&
              (pubJson['files'] as List).isNotEmpty) {
            publications.add(Publication.fromJson(pubJson));
          } else {
            // Optionnel: Log si une publication est ignorée en raison de l'absence de fichiers
            print(
                "Publication ignorée (pas de fichiers ou fichiers vides) : ${pubJson['id']}");
          }
        }
        print("Taille des pubs récupérées: ${publications.length}");
        return publications;
      } else {
        // En cas d'erreur de statut HTTP, lancez une exception
        // pour que l'AsyncNotifier puisse capturer et exposer l'état d'erreur.
        throw Exception("Erreur de statut HTTP: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      // Pour un meilleur débogage, imprimez la pile d'appels
      print("Erreur lors de la récupération des publications: $e");
      print("Stack trace: $stackTrace");
      // Relancez l'exception pour que l'AsyncNotifier passe à l'état AsyncValue.error
      throw Exception("Échec de la récupération des publications: $e");
    }
  }

  // Méthode publique pour rafraîchir les publications (appelée par l'UI par ex.)
  Future<void> refreshPublications() async {
    // Met l'état à `loading` pendant le rafraîchissement
    state = const AsyncValue.loading();
    // Attend la nouvelle liste de publications
    state = await AsyncValue.guard(() => _fetchPublications());
  }

  Future<void> addPublication(Publication newPublication) async {
    // Option 1: Mettre à jour l'état directement si vous ne voulez pas recharger toutes les pubs
    // Ceci est plus performant si l'ajout ne nécessite pas un rechargement complet du serveur.
    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, newPublication]);
    } else {
      // Si l'état n'a pas encore de données (ex: erreur ou chargement initial),
      // déclenchez un rafraîchissement complet.
      await refreshPublications();
    }
  }

  // Exemple: Supprimer une publication
  Future<void> deletePublication(String publicationId) async {
    // Si l'état actuel a des données
    if (state.hasValue) {
      // Filtre la liste pour supprimer la publication
      final updatedList =
          state.value!.where((pub) => pub.id != publicationId).toList();
      state = AsyncValue.data(updatedList); // Met à jour l'état
      // Ici, vous feriez aussi l'appel API pour supprimer du backend
      // try {
      //   await PublicationService.deletePublication(publicationId);
      // } catch (e) {
      //   // Gérer l'erreur de suppression, peut-être restaurer la publication localement
      //   print("Erreur de suppression sur le backend: $e");
      //   // Peut-être invalider le provider pour recharger l'état du serveur
      //   ref.invalidateSelf();
      // }
    }
  }
}

// Le provider qui expose votre PublicationNotifier
final publicationProvider =
    AsyncNotifierProvider<PublicationNotifier, List<Publication>>(
  () => PublicationNotifier(),
);
