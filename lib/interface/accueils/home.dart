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

  loadVideoTenVideoController() {
    for (int i = 0; i < DataController.videos.length && i < 10; i++) {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(DataController.videos[i].files[0].url!))
        ..initialize().then((value) {
          videoPlayerController.setLooping(true);
          videoPlayerController.pause();
          setState(() {});
          Map video = {
            'id': DataController.videos[i].id,
            'controller': videoPlayerController
          };
          DataController.addVideoToHistory(
              DataController.videos[0].id!, videoPlayerController);
        });
      DataController.addVideoToHistory(
          DataController.videos[i].id!, videoPlayerController);
    }
  }

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
              if (pub.files[0].type == 'video') {
                DataController.videos.add(pub);
              }
            }
          }
          loadVideoTenVideoController();
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
                  ? PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: DataController.videos.length,
                      padEnds: true,
                      onPageChanged: (index) {
                        // setState(() {
                        //   currentPage=index;
                        // });
                        //arret de la vidéo précedente
                      },
                      itemBuilder: (context, index) {
                        return DataController.videos.isNotEmpty
                            ? VideoPlayerWidget(
                                videoItem: DataController.videos[index],
                                index: index,
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
                    )
                  : Container(
                      child: const Text("Aucune publication"),
                    );
            }));
  }

  videoContainer() {
    return Container(
      child: VideoPlayer(videoPlayerController),
    );
  }
}
