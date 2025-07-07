import 'package:application_amonak/interface/accueils/home.dart'; // Assurez-vous que ce chemin est correct
import 'package:application_amonak/notifier/PublicationNotifier.dart'; // Assurez-vous que ce chemin est correct
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart'; // Utilisez material.dart pour la plupart des widgets Flutter
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationList extends ConsumerWidget {
  const PublicationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Écoutez l'état asynchrone de vos publications
    // ref.watch(publicationProvider) vous donnera un AsyncValue<List<Publication>>
    final asyncPublications = ref.watch(publicationProvider);

    // 2. Utilisez la méthode .when() d'AsyncValue pour gérer les différents états
    return asyncPublications.when(
      // État de succès : les données sont disponibles
      data: (publications) {
        // Optionnel : Si la liste est vide, affichez un message clair
        if (publications.isEmpty) {
          return const Center(
            child: Text(
              "Aucune publication disponible pour le moment.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        // Affichez vos publications en utilisant le VideoScrollWidget
        return VideoScrollWidget(publications: publications);
      },
      // État d'erreur : une erreur est survenue lors du chargement
      error: (error, stackTrace) {
        // Vous pouvez afficher l'erreur pour le débogage ou un message plus convivial
        print('Erreur de chargement des publications: $error');
        print('Stack trace: $stackTrace');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Oups ! Une erreur est survenue lors du chargement des publications.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              // Optionnel : Afficher le message d'erreur réel en mode debug
              // Text(
              //   'Détails: ${error.toString()}',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 12, color: Colors.grey),
              // ),
              const SizedBox(height: 20),
              // Bouton pour réessayer le chargement
              ElevatedButton.icon(
                onPressed: () {
                  // Invalide le provider pour forcer un rechargement des données
                  ref.invalidate(publicationProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Réessayer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor, // Couleur du bouton
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      // État de chargement : les données sont en cours de récupération
      loading: () => const WaitWidget(), // Affiche votre widget d'attente
    );
  }
}
