import 'package:application_amonak/interface/explorer/ExplorerSearchWidget.dart';
import 'package:application_amonak/notifier/BoutiqueNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:application_amonak/widgets/wait_widget.dart';

import 'package:application_amonak/widgets/publication_card.dart';

class BoutiquePage2 extends ConsumerStatefulWidget {
  const BoutiquePage2({super.key});

  @override
  ConsumerState<BoutiquePage2> createState() => _BoutiquePageState();
}

class _BoutiquePageState extends ConsumerState<BoutiquePage2> {
  final TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(boutiqueProvider.notifier).loadBoutiques();
    });

    // _scrollController.addListener(() {
    //   final state = ref.read(boutiqueProvider);
    //   if (_scrollController.position.pixels >=
    //           _scrollController.position.maxScrollExtent - 200 &&
    //       !state.loading &&
    //       state.hasMore) {
    //     ref.read(boutiqueProvider.notifier).loadBoutiques(
    //           search: search.text.isEmpty ? null : search.text,
    //         );
    //   }
    // });
  }

  void onSearchChanged(String value) {
    // Appeler la méthode de recherche dans le notifier
    ref.read(boutiqueProvider.notifier).loadBoutiques(
          search: value.isEmpty ? null : value,
          refresh: true,
        );

    if (value.length >= 3) {
      ref.read(boutiqueProvider.notifier).searchBoutique(
            search: value,
          );
    } else {
      ref.read(boutiqueProvider.notifier).loadBoutiques(
            refresh: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(boutiqueProvider);

    return Column(
      children: [
        ExplorerSearchWidget(
          onSearchChanged: onSearchChanged,
          searchController: search,
        ),
        Expanded(
          // child: RefreshIndicator(
          // onRefresh: () async {
          //   await ref
          //       .read(boutiqueProvider.notifier)
          //       .loadBoutiques(search: search.text, refresh: true);
          // },
          child: state.loading && state.boutiques.isEmpty
              ? const WaitWidget()
              : state.error != null && state.boutiques.isEmpty
                  ? Center(child: Text(state.error!))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: state.boutiques.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.boutiques.length) {
                          // loader en bas pour infinite scroll
                          return state.hasMore
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink();
                        }
                        final boutique = state.boutiques[index];
                        return GestureDetector(
                            onTap: () {
                              // Navigation vers la page détail
                            },
                            child: itemPublication(boutique, 2));
                      },
                    ),
        ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
