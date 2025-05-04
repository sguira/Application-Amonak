import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget2 extends StatefulWidget {
  final String url;
  const VideoPlayerWidget2({super.key,required this.url});

  @override
  State<VideoPlayerWidget2> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget2> {

  VideoPlayerController? videoPlayerController;

  late int nbLike=0;
  late bool isLiked=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("urlll ${widget.url}\n\n");
    initializeVideoPlayer();
  }

  

  @override
  void dispose() {
    
    super.dispose();
    videoPlayerController!.dispose();
  }

  initializeVideoPlayer()async{
    videoPlayerController =VideoPlayerController.networkUrl(Uri.parse(widget.url))
    ..initialize().then((value) {
      videoPlayerController!.pause();
      videoPlayerController!.setVolume(75);
      videoPlayerController!.setLooping(true);
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio*2,
      
      child: videoPlayerController!.value.isInitialized? Stack(
        children: [
          Positioned(
            // top: 150, 
            left: ScreenSize.width*0.4,
            child: Center(
              child:IconButton(onPressed: (){}, icon:const Icon(Icons.play_arrow,color: Colors.red,))
            ),
          ),
          
          GestureDetector(
            onTap: (){
              if(videoPlayerController!.value.isPlaying){
                videoPlayerController!.pause();
              }
              else{
                videoPlayerController!.play();
              }
            },
            child: Container(
              constraints: const BoxConstraints(
                // maxHeight: 450
              ),
              child: VideoPlayer(
                 
                videoPlayerController!, 
              
                ),
            ),
          ),
          Center(
            child: Positioned(
              // bottom: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5)
                ),
                child:IconButton(onPressed: (){
                  if(videoPlayerController!.value.isPlaying){
                    setState(() {
                      videoPlayerController!.pause();
                    });
                  }
                  else{
                    setState(() {
                      videoPlayerController!.play();
                    });
                  }
                }, icon: Icon(!videoPlayerController!.value.isPlaying? Icons.play_arrow:Icons.pause,color: Colors.black,size: 24,))
              )
            ),
          ),
        ],
      ):Container(
      margin:const EdgeInsets.symmetric(horizontal: 12),
      child:const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    ),
    );
  }
}