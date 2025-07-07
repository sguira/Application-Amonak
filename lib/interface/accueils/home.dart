import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/accueils/video_player_widget.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:flutter/material.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> colors = [Colors.red, Colors.blue, Colors.yellow, Colors.green];

  late Future<void> _initializeVideoPlayerFuture;

  late VideoPlayerController videoPlayerController;

  int videoIndex = 0;

  int currentPage = 0;

  Notificationsocket? notificationsocket;
  final PageController pageController = PageController(
      // viewportFraction: 0.1,

      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationsocket = Notificationsocket();
    _initializeVideoPlayerFuture = DataController.videos.length == 0
        ? loadVideos()
        : Future.delayed(Duration(milliseconds: 100), () {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // videoPlayerController.dispose();
  }

  Future<void> loadVideos() async {
    await PublicationService.getPublications().then((value) {
      try {
        print("value ss ${value.body}\n\n\n");
        if (value.statusCode.toString() == '200') {
          DataController.videos = [];
          for (var item in jsonDecode(value.body) as List) {
            if (item['type'] != 'share') {
              Publication pub = Publication.fromJson(item);
              print("content- ${pub.content} ${pub.files[0].type}");
              print("typesss ${pub.files[0].type} ");
              if (pub.files[0].type == 'video' ||
                  pub.files.first.type == 'image') {
                DataController.videos.add(pub);
              }
            }
          }
          // loadVideoTenVideoController();
        }
      } catch (e) {
        print(e);
      }
    }).catchError((e) {
      print("ERROR $e\n\n\n");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        color: couleurPrincipale,
                      ),
                    ),
                    Text("chargement des vidéos")
                  ],
                );
              }
              if (snapshot.hasError) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text("Error")),
                  ],
                );
              }
              return DataController.videos.isNotEmpty
                  ? VideoScrollWidget(
                      publications: DataController.videos,
                    )
                  : Container(
                      child: const Text("Aucune publication"),
                    );
            }));
  }
}

class VideoScrollWidget extends StatefulWidget {
  const VideoScrollWidget({
    super.key,
    required this.publications,
  });

  final List<Publication> publications;

  @override
  State<VideoScrollWidget> createState() => _VideoScrollWidgetState();
}

class _VideoScrollWidgetState extends State<VideoScrollWidget> {
  PageController pageController = PageController();
  int? currentPage;

  @override
  void initState() {
    // TODO: implement initState
    // pageController!.addListener(() {
    //   final page = pageController!.page?.round();
    //   if (page != null && page != currentPage) {
    //     setState(() {
    //       currentPage = page;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.publications.length,
      padEnds: true,
      onPageChanged: (index) {
        // setState(() {
        //   currentPage=index;
        // });
        //arret de la vidéo précedente
      },
      itemBuilder: (context, index) {
        return widget.publications.isNotEmpty
            ? VideoPlayerWidget(
                videoItem: widget.publications[index],
                index: index,
                isCurrentPage: currentPage == index,
              )
            : const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text("Aucune publication"),
                  )
                ],
              );
      },
    );
  }
}
