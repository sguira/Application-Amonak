import 'package:application_amonak/interface/accueils/home.dart';
import 'package:application_amonak/notifier/PublicationNotifier.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationList extends ConsumerWidget {
  const PublicationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPublications = ref.watch(publicationProvider);

    return asyncPublications.when(
        data: (publications) => VideoScrollWidget(publications: publications),
        error: (error, _) => const Center(
              child: Text("Une erreur est survenue"),
            ),
        loading: () => const WaitWidget());
  }
}
