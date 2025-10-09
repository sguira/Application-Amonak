import 'dart:convert';
import 'dart:ui';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/data/video_controller_cache.dart'; // Import the new cache
import 'package:application_amonak/interface/accueils/notifications.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/interface/vendre/vendre.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/notifier/PublicationNotifierFianl.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/ResponseAlerteWidget.dart';
import 'package:application_amonak/widgets/btnLike.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/buttonComment.dart';
import 'package:application_amonak/widgets/commentaire.dart';
import 'package:application_amonak/widgets/imageSkeleton.dart';
import 'package:application_amonak/widgets/notification_button.dart';
import 'package:application_amonak/widgets/share_widget.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final Publication videoItem;
  final int index;
  final bool isCurrentPage;

  const VideoPlayerWidget({
    super.key,
    required this.videoItem,
    required this.index,
    required this.isCurrentPage,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  VideoPlayerController? controller;
  final VideoControllerCache _videoCache =
      VideoControllerCache(); // Get the cache instance

  PageController pageController = PageController();

  int currentpage = 0;

  int nbLike = 0;
  bool isLike = false;
  late String idLike;
  bool viewBtn = false;
  List hearts = [];
  double sizeLike = 12;
  bool showFavourite = false;
  bool isExpanded = false;
  nombreComment() async {
    await CommentaireService.getCommentByPublication(
            pubId: widget.videoItem.id!)
        .then((value) {
      if (value.statusCode.toString() == '200') {
        setState(() {
          nbComment = (jsonDecode(value.body) as List).length;
        });
      }
    });
  }

  Future getArticle() async {
    if (widget.videoItem.typePub == 'sale') {
      await ProductService.getSingleArticle(id: widget.videoItem.productId)
          .then((value) {
        if (value.statusCode == 200) {
          article = ArticleModel.fromJson(jsonDecode(value.body));
        }
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    }
  }

  ArticleModel? article;

  int nbComment = 0;

  List likes = [];
  String? type;

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (type == 'video' &&
        controller != null &&
        controller!.value.isInitialized) {
      if (widget.isCurrentPage) {
        setState(() {
          controller!.play();
        });
      } else {
        setState(() {
          controller!.pause();
          controller!.seekTo(Duration.zero);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    type = widget.videoItem.files.first.type;
    getArticle();

    setState(() {
      getNombreLike();
      nombreComment();
    });
    Future.microtask(
        () => ref.read(publicationProvider22.notifier).setMemory(true));

    if (widget.videoItem.files.first.type == 'video') {
      // Try to get controller from cache
      controller = _videoCache.getController(widget.videoItem.id!);

      if (controller == null) {
        // If not in cache, create a new one
        controller = VideoPlayerController.networkUrl(
            Uri.parse(widget.videoItem.files[0].url!));
        controller!.initialize().then((_) {
          controller!.setLooping(true);

          setState(() {
            viewBtn = true; // Set viewBtn to true after initialization
          });
          // Add the newly initialized controller to the cache
          _videoCache.addController(widget.videoItem.id!, controller!);

          setState(() {
            controller!.play();
          });
        }).catchError((e) {
          if (kDebugMode) {
            print('Error initializing video controller: $e');
          }
          // Handle error, e.g., show a placeholder or error message
        });
      } else {
        // If controller exists in cache, just set viewBtn and play/pause based on current page
        setState(() {
          viewBtn = true; // Controller is already initialized
        });
        if (widget.isCurrentPage) {
          setState(() {
            controller!.play();
          });
        } else {
          setState(() {
            controller!.pause();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    if (type == 'video' && controller != null) {
      // Pause the video when the widget is disposed to prevent background audio
      setState(() {
        controller!.pause();
      });
      // Optional: You could choose to dispose here if you don't want to cache controllers
      // controller!.dispose();
    }
    super.dispose();
  }

  getNombreLike() async {
    await PublicationService.getNumberLike(widget.videoItem.id!, 'like')
        .then((value) {
      if (kDebugMode) {
        print("nombre like");
      }
      if (value!.statusCode.toString() == '200') {
        setState(() {
          nbLike = (jsonDecode(value.body) as List).length;
          if (kDebugMode) {
            print("nombre de like $nbLike\n\n $isLike");
          }
        });

        if (nbLike > 0) {
          for (var i in jsonDecode(value.body) as List) {
            if (i['user'] != null) {
              if (i['user']['_id'] == DataController.user!.id) {
                setState(() {
                  isLike = true;
                  idLike = i['_id'];
                });
              }
            }
          }
        }
      }
    }).catchError((e) {
      setState(() {
        isLike = false;
        nbLike = 0;
      });
      if (kDebugMode) {
        print("ERORRRT $e \n\n");
      }
    });
  }

  deleteLike() async {
    if (isLike) {
      await PublicationService.deleteLike(idLike).then((value) {
        if (kDebugMode) {
          print("SUppression like ${value.statusCode} .. \n\n");
        }
        setState(() {
          isLike = false;
          nbLike -= 1;
        });
        if (value.statusCode.toString() != '200') {
          setState(() {
            isLike = true;
            nbLike += 1;
          });
        }
      }).catchError((e) {
        setState(() {
          isLike = true;
          nbLike += 1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      if (ref.watch(publicationProvider22).isMemory == false) {
        if (controller != null) {
          controller!.pause();
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    showFavourite = true;
                  });
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    setState(() {
                      showFavourite = false;
                    });
                  });
                  if (isLike == false) {
                    likePublication();
                  } else {
                    deleteLike();
                  }
                },
                onTapUp: (details) {
                  if (kDebugMode) {
                    print("on tap Up");
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          viewBtn = !viewBtn;
                        });
                        Future.delayed(const Duration(milliseconds: 4000), () {
                          setState(() {
                            viewBtn = false;
                          });
                        });
                      },
                      child: Container(
                          child: widget.videoItem.files.first.type == 'video'
                              ? (controller != null &&
                                      controller!.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          controller!.value.aspectRatio,
                                      child: VideoPlayer(controller!))
                                  : const WaitWidget())
                              : Center(
                                  child: LoadImage(
                                  imageUrl: widget.videoItem.files.first.url,
                                  fit: BoxFit.cover,
                                ))),
                    ),
                    if (viewBtn)
                      if (type == 'video')
                        GestureDetector(
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.transparent,
                            child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(58),
                                    color: Colors.black.withAlpha(40)),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (controller!.value.isPlaying) {
                                          controller!.pause();
                                        } else {
                                          controller!.play();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      controller!.value.isPlaying
                                          ? Icons
                                              .pause // Changed to pause when playing
                                          : Icons
                                              .play_arrow, // Changed to play when paused
                                      color: Colors.black.withAlpha(100),
                                      size: 56,
                                    ))),
                          ),
                        ),
                  ],
                ),
              ),
            ),
            header(),
            if (widget.videoItem.typePub == 'alerte' && false)
              Positioned(
                // bottom: MediaQuery.of(context).size.height * 0.5,
                // left: MediaQuery.of(context).size.width * 0.5 - 80,
                child: Center(
                  child: FloatingActionButton.extended(
                    elevation: 8,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ResponseAlerteWidget(
                              publication: widget.videoItem));
                    },
                    label: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: couleurPrincipale,
                            borderRadius: BorderRadius.circular(38)),
                        child: Text("Répondre")),
                  ),
                ),
              ),
            if (showFavourite == true)
              Animate(
                  effects: const [
                    ScaleEffect(duration: Duration(milliseconds: 500)),
                    ShakeEffect(duration: Duration(milliseconds: 500))
                  ],
                  child: const Center(
                      child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 90,
                  ))),
            containerButton(),
            containerDescription()
          ],
        ),
      ),
    );
  }

  containerDescription() {
    return widget.videoItem.content!.isNotEmpty
        ? Positioned(
            bottom: 20,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(60),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article != null)
                    Container(
                      margin:
                          const EdgeInsets.only(right: 12, left: 12, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NumberFormat.currency(
                                    locale: 'fr',
                                    decimalDigits: 0,
                                    symbol: article!.currency!)
                                .format(article!.price),
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Text(
                            article!.name!,
                            style: GoogleFonts.roboto(color: Colors.white),
                          ),
                          Text(
                            "Stock: ${article!.qte}",
                            style: GoogleFonts.roboto(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  TextExpanded(),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  )
                ],
              ),
            ))
        : const Center();
  }

  calculateDiffenceDate({required DateTime from, required DateTime to}) {
    // int seconde=to.difference(other)
  }

  Container TextExpanded() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        width: ScreenSize.width * 0.75,
        constraints: BoxConstraints(
            maxHeight: isExpanded == false ? 130 : ScreenSize.height * 0.6),
        child: SingleChildScrollView(
          child: widget.videoItem.content!.length > 100
              ? Text.rich(TextSpan(children: [
                  TextSpan(
                      text: isExpanded == false
                          ? super.widget.videoItem.content!.substring(0, 100)
                          : widget.videoItem.content!,
                      style: GoogleFonts.roboto(color: Colors.white)),
                  TextSpan(
                      text:
                          isExpanded == false ? " voir plus..." : "voir moins",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        })
                ]))
              : Text(
                  widget.videoItem.content!,
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
        ));
  }

  Positioned containerButton() {
    return Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 22),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60),
                    borderRadius: BorderRadius.circular(22)),
                child: Column(
                  children: [
                    ButtonLike(
                      pub: widget.videoItem,
                      color: Colors.white,
                    ),
                    CommentaireButton(
                      pubId: widget.videoItem.id!,
                      color: Colors.white,
                      pub: widget.videoItem,
                    ),
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                // onComment();
                                showCustomModalSheetWidget(
                                    context: context,
                                    child:
                                        ShareWidget(itemPub: widget.videoItem));
                              },
                              icon: const Icon(Icons.repeat,
                                  color: Colors.white)),
                          // Text(
                          //   NumberFormat.compact(locale: 'fr').format(0),
                          //   style: GoogleFonts.roboto(
                          //       fontSize: sizeLike, color: Colors.white),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.videoItem.typePub == 'sale' ||
                  widget.videoItem.typePub == "alerte")
                itemButtonStyleBackground()
            ],
          ),
        ));
  }

  header() {
    return Positioned(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withAlpha(68)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailsUser(user: widget.videoItem.user!)));
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(86)),
              child: ClipOval(
                  child: widget.videoItem.user!.avatar!.isEmpty
                      ? Image.asset(
                          'assets/medias/profile.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.videoItem.user!.avatar![0].url!,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Container(
            child: Text(
              widget.videoItem.userName!.toUpperCase(),
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          const ButtonNotificationWidget(
            color: Colors.white,
          )
        ],
      ),
    ));
  }

  Container itemButtonStyleBackground() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: couleurPrincipale, width: 2)),
            child: IconButton(
                onPressed: () {
                  if (widget.videoItem.typePub != "alerte") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendrePage(
                                articleId: widget.videoItem.productId,
                                article: null)));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => ResponseAlerteWidget(
                            publication: widget.videoItem));
                  }
                },
                icon: Icon(widget.videoItem.typePub != "alerte"
                    ? Icons.shopping_cart
                    : Icons.message)),
          ),
          Text(
            widget.videoItem.typePub != "alerte"
                ? NumberFormat.compact().format(10000)
                : "Répondre",
            style: GoogleFonts.roboto(
                fontSize: 11, color: Colors.white, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  itemButton(int value, IconData icon, Function function) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            IconButton(
                onPressed: function(),
                icon: Icon(
                  icon,
                  color: isLike == false ? Colors.white : Colors.red,
                )),
            Text(
              NumberFormat.compact(locale: 'fr').format(value),
              style: GoogleFonts.roboto(fontSize: 8, color: Colors.white),
            )
          ],
        ),
      );

  void onLiker() {
    setState(() {
      if (isLike) {
        deleteLike();
      } else {
        likePublication();
      }
    });
  }

  void onShare() {}

  onComment() {
    if (kDebugMode) {
      print("Commentaire \n\n");
    }
    return showCustomModalSheetWidget(
        context: context,
        child: CommentaireWidget(
            pubId: widget.videoItem.id, pub: widget.videoItem));
  }

  likePublication() async {
    Map data = {
      "publication": widget.videoItem.id,
      "user": DataController.user!.id,
      "type": 'like'
    };
    if (isLike == false) {
      setState(() {
        isLike = true;
        nbLike += 1;
      });
      PublicationService.addLike(data).then((value) {
        if (kDebugMode) {
          print("Status like ${value.statusCode}\n\n");
        }
        if (value.statusCode.toString() != '200') {
          setState(() {
            isLike = false;
            nbLike -= 1;
          });
        }
      }).catchError((e) {
        setState(() {
          isLike = false;
          nbLike -= 1;
        });
      });
    }
  }
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({super.key});

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
        CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeOut));

    _controllerAnimation.forward();
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controllerAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 50,
        ),
      ),
    );
  }
}
