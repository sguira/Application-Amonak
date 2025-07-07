import 'dart:convert';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/publication.dart'; // Assurez-vous que ce chemin est correct
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Définissez votre notifier
class NotificationNotifier extends AsyncNotifier<List<NotificationModel>> {
  // La méthode `build` est l'endroit où vous initialisez l'état asynchrone.
  // Elle est appelée une seule fois au premier accès au provider.
  @override
  Future<List<NotificationModel>> build() async {
    return _fetchPublications();
  }

  // Méthode privée pour la logique de récupération des publications.
  // Ne modifiez pas directement `state` ici, laissez `build` gérer le premier chargement.
  // Pour les rechargements ultérieurs, utilisez `ref.invalidate` ou mettez à jour `state` directement.
  Future<List<NotificationModel>> _fetchPublications() async {
    try {
      final response = await NotificationService.getNotification();
      if (response!.statusCode == 200) {
        List<NotificationModel> notifications = [];
        for (var pubJson in jsonDecode(response.body)) {
          notifications.add(NotificationModel.fromJson(pubJson));
        }
        DataController.notificationCount = notifications.length;
        return notifications;
      } else {
        throw Exception("Erreur de statut HTTP: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      throw Exception("Échec de la récupération des publications: $e");
    }
  }

  // Méthode publique pour rafraîchir les publications (appelée par l'UI par ex.)
  Future<void> refreshPublications() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPublications());
  }

  Future<void> addPublication(NotificationModel newNotification) async {
    // Option 1: Mettre à jour l'état directement si vous ne voulez pas recharger toutes les pubs
    // Ceci est plus performant si l'ajout ne nécessite pas un rechargement complet du serveur.
    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, newNotification]);
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
      try {
        await NotificationService.deleteNotification(publicationId);
      } catch (e) {
        // Gérer l'erreur de suppression, peut-être restaurer la publication localement
        print("Erreur de suppression sur le backend: $e");
        // Peut-être invalider le provider pour recharger l'état du serveur
        ref.invalidateSelf();
      }
    }
  }
}

// Le provider qui expose votre PublicationNotifier
final notificationProvider =
    AsyncNotifierProvider<NotificationNotifier, List<NotificationModel>>(
  () => NotificationNotifier(),
);
