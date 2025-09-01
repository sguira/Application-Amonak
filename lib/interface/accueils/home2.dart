import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/home.dart'; // Assurez-vous que ce chemin est correct
import 'package:application_amonak/notifier/NotificationNotifier.dart';
import 'package:application_amonak/notifier/PublicationNotifierFianl.dart';
import 'package:application_amonak/widgets/error_widget.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart'; // Utilisez material.dart pour la plupart des widgets Flutter
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationList extends ConsumerStatefulWidget {
  const PublicationList({super.key});

  @override
  ConsumerState<PublicationList> createState() => _PublicationListState();
}

class _PublicationListState extends ConsumerState<PublicationList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => ref.read(publicationProvider22.notifier).loadArticles());
  }

  @override
  Widget build(BuildContext context) {
    final asyncPublications = ref.watch(publicationProvider22);

    return Scaffold(
      body: Container(
        child: asyncPublications.loading == true
            ? WaitWidget()
            : (asyncPublications.loading == false &&
                    asyncPublications.error != '' &&
                    asyncPublications.error != null)
                ? CustomErrorWidget()
                : Container(
                    child: VideoScrollWidget(
                        publications: asyncPublications.publication),
                  ),
      ),
    );
  }
}
