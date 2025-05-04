import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBacground extends StatefulWidget {
  final String url;
  const VideoBacground({super.key, required this.url});

  @override
  State<VideoBacground> createState() => _VideoBacgroundState();
}

class _VideoBacgroundState extends State<VideoBacground> {

  VideoPlayerController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=VideoPlayerController.networkUrl(Uri.parse(widget.url))
    ..initialize().then((value) {
      setState(() {
        
      });
      controller!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:controller!.value.isInitialized? AspectRatio(
        aspectRatio: controller!.value.aspectRatio, 
        child: Stack(
          children: [
            VideoPlayer(controller!), // VideoPlayer
          ],
        ),
      ):const WaitWidget(label: 'Chargement de la vidéo',),
    );
  }
}