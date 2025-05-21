import 'dart:convert';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationNotifier extends AsyncNotifier<List<Publication>> {
  @override
  Future<List<Publication>> build() async {
    return await fetchPublications();
  }

  Future<List<Publication>> fetchPublications() async {
    try {
      final response =
          await PublicationService.getPublications(); // Await directly
      if (response.statusCode == 200) {
        List<Publication> publications = [];
        for (var pub in jsonDecode(response.body)) {
          print("pub pubv: $pub");
          print("Publication: $pub");
          if (pub['files'] != null && pub['files'].length > 0) {
            // Safety check for 'files'
            publications.add(Publication.fromJson(pub));
          }
        }
        print("taille des pubs: ${publications.length}");
        return publications; // Return the publications here
      } else {
        print(
            "Erreur de statut lors de la récupération des publications: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erreur lors de la récupération des publications: $e");
      return [];
    }
  }
}

final publicationProvider =
    AsyncNotifierProvider<PublicationNotifier, List<Publication>>(
        () => PublicationNotifier());
