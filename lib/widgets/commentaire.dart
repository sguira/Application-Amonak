import 'dart:convert';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/ccommentaire.dart';
import 'package:application_amonak/models/like.dart';
import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/commentaire.dart';
import 'package:application_amonak/services/like.dart';
import 'package:application_amonak/services/notification.dart';
import 'package:application_amonak/services/socket/commentSocket.dart';
import 'package:application_amonak/services/socket/notificationSocket.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/bottom_sheet_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommentaireWidget extends StatefulWidget {
  final String? pubId;
  final Publication pub;
  const CommentaireWidget({super.key, this.pubId, required this.pub});

  @override
  State<CommentaireWidget> createState() => _CommentaireWidgetState();
}

class _CommentaireWidgetState extends State<CommentaireWidget> {
  // Publication pub=Publication();
  String pubId = "";
  // Commentsocket? commentsocket;

  IO.Socket? socket;

  late Notificationsocket notificationsocket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pubId = super.widget.pubId!;
    // commentsocket=Commentsocket();
    // print("PUBLICATION ${pub.id}");

    //socket
    socket = IO.io(
        "$apiLink/comment",
        IO.OptionBuilder().setPath("/amonak-api").setTransports(["websocket"])
            // .disableAutoConnect()
            //
            .build());

    socket!.onConnect((handler) {
      print("Connected to comment socket");
    });

    socket!.onDisconnect((handler) {
      print("Disconnected from comment socket");
    });

    socket!.on(
        "newCommentEventListener",
        (data) => {
              print(data),
              if (data['publication'] == widget.pubId)
                {
                  setState(() {
                    if (commentaires.isNotEmpty) {
                      commentaires.insert(1, Commentaire.fromJson(data));
                    } else {
                      commentaires.add(Commentaire.fromJson(data));
                    }
                  }),
                },
              print("newCommentEventListener")
            });

    socket!.on(
        "likeCommentListener",
        (data) => {
              print(data),
              for (int index = 0; index < commentaires.length; index++)
                {
                  if (commentaires[index].id == data["comment"])
                    {
                      setState(() {
                        commentaires[index].nbLikes =
                            commentaires[index].nbLikes! + 1;
                      })
                    }
                }
            });
    notificationsocket = Notificationsocket();
  }

  @override
  void dispose() {
    // commentsocket!.dispose();
    socket!.close();
    super.dispose();
  }

  TextEditingController content = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  List<Commentaire> commentaires = [];

  bool waitComment = false;

  @override
  Widget build(BuildContext context) {
    if (pubId.isNotEmpty) {
      return FutureBuilder(
          future: CommentaireService.getCommentByPublication(pubId: pubId)
              .then((value) {
            print("Status code ${value.statusCode}");
            if (value.statusCode.toString() == '200') {
              commentaires = [];
              for (var map in jsonDecode(value.body) as List) {
                print(map);
                print("\n\n\n");
                commentaires.add(Commentaire.fromJson(map));
              }
              // print("Status code ${value.statusCode}");
            }
          }).catchError((e) {
            print("Une erreur est survenu $e");
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return zoneCommentaire(pubId);
            }
            if (snapshot.hasError) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Erreur de chargement "),
                    ),
                  ],
                ),
              );
            }
            return zoneCommentaire(pubId);
          });
    } else {
      return const Center();
    }
  }

  zoneCommentaire(
    String id,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
          ]),
      child: Column(
        children: [
          headerBottomSheet(context, "Commentaires"),
          Expanded(
              child: commentaires.isNotEmpty
                  ? ListView.builder(
                      itemCount: commentaires.length,
                      itemBuilder: (context, index) {
                        // commentaires[index].
                        return Column(
                          children: [
                            ItemCommentaire(
                              com: commentaires[index],
                              setState_: setState,
                              pubId: widget.pubId!,
                            ),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text("Aucun commentaire Trouvé."),
                    )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(5)),
            child: Form(
              key: keyForm,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        // height: 48,
                        child: TextFormField(
                          maxLines: null,
                          controller: content,
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Veuillez entrer un commentaire";
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.roboto(fontSize: 13),
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            hintText: 'Votre commentaire',
                            hintStyle: GoogleFonts.roboto(fontSize: 12),
                            isCollapsed: true,
                            border: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(26),
                                borderSide: BorderSide(
                                    color: couleurPrincipale, width: 2)),
                            focusedBorder: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(26),
                                borderSide: BorderSide(
                                    color: couleurPrincipale, width: 2)),
                            enabledBorder: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(26),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 2)),
                          ),
                        ),
                      )),
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: TextButton(
                            onPressed: () async {
                              if (keyForm.currentState!.validate()) {
                                ajouterCommentaire(pubId);
                              }
                            },
                            child: waitComment == false
                                ? Column(
                                    children: [
                                      const Icon(Icons.send),
                                      Text(
                                        'Commenter',
                                        style: GoogleFonts.roboto(fontSize: 7),
                                      )
                                    ],
                                  )
                                : Container(
                                    child: const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buttonReatComment(String label, Function onPressed) {
    return Container(
        margin: const EdgeInsets.all(6),
        child: GestureDetector(
            onTap: onPressed(),
            child: Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                      fontSize: 9, fontWeight: FontWeight.w500),
                ),
              ],
            )));
  }

  ajouterCommentaire(String pubId) async {
    Commentaire com = Commentaire();
    com.content = content.text;
    com.userId = DataController.user!.id;
    com.publicationId = pubId;

    Map<String, dynamic> notificationData = {
      'publication': pubId,
      'from': DataController.user!.id,
      'to': widget.pub.user!.id,
      'type': 'comment'
    };

    setState(() {
      waitComment = true;
    });
    CommentaireService.saveComent(com).then((value) {
      if (value.statusCode == 200) {
        // print("donnée ${jsonDecode(value.body)}");
        setState(() {
          // commentaires.insert(1, Commentaire.fromJson(jsonDecode(value.body)));
          var com = Commentaire.fromJson(jsonDecode(value.body));
          com.isLike = false;
          commentaires = [com, ...commentaires];
        });
        print("Commentaire...");
        socket!.emit("newCommentEvent", {
          "from": jsonEncode(DataController.user),
          "comment": jsonDecode(value.body)
        });
        notificationData['commentaire'] = jsonDecode(value.body)['_id'];
        NotificationService.addNotification(notificationData);
        content.clear();
        // notificationsocket.emitNotificationEvent(
        //     event: "refreshNotificationBox",
        //     data: {
        //       "from": DataController.user!.id,
        //       "to": jsonDecode(value.body)['user']['_id']
        //     });
      }
      setState(() {
        waitComment = false;
      });
    }).catchError((e) {
      print("Error");
    });
  }

  isLiked(Commentaire com, String id) {
    for (Like like in com.likes!) {
      if (like.userId == id) {
        return true;
      }
    }
    return false;
  }
}

class ItemCommentaire extends StatefulWidget {
  final Commentaire com;
  final dynamic setState_;
  final String pubId;
  // final IO.Socket? socket;
  const ItemCommentaire(
      {super.key,
      required this.com,
      required this.setState_,
      required this.pubId});

  @override
  State<ItemCommentaire> createState() => _ItemCommentaireState();
}

class _ItemCommentaireState extends State<ItemCommentaire> {
  late bool isLiked = false;

  late Commentaire commentaire;

  String likeId = "";

  bool showActions = false;

  Commentsocket? commentsocket;

  @override
  void initState() {
    super.initState();
    // print("user id ${DataController.user!.id}\n\n\n");
    isLiked = widget.com.isLike;
    commentsocket = Commentsocket();
    commentsocket!.socket!.onConnect((e) {
      print("Item connected");
    });
    commentaire = widget.com;

    LikeService.getNombreLike(commentaire.id!).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          commentaire.nbLikes = (jsonDecode(value.body) as List).length;
        });
      }
    });

    LikeService.getLikeByUser(
            commentId: commentaire.id!, userId: DataController.user!.id!)
        .then((value) {
      if (value.statusCode == 200) {
        for (var item in jsonDecode(value.body)) {
          if (item['user'] == DataController.user!.id) {
            setState(() {
              isLiked = true;
              commentaire.isLike = true;
              likeId = item['_id'];
              return;
            });
          } else {
            setState(() {
              isLiked = false;
              commentaire.isLike = false;
            });
          }
        }
      }
    }).catchError((e) {
      setState(() {
        isLiked = false;
        commentaire.isLike = false;
      });
      return e;
    });
    setState(() {
      isLiked = commentaire.isLike;
    });
    // print("Publication Id: ${commentaire.id}");
    // print(" nombre like ${commentaire.nbLikes}");
  }

  // getNombreLike(String id)async{

  // }

  @override
  void dispose() {
    commentsocket!.dispose();
    super.dispose();
  }

  likeCommentaire(Commentaire commentaire) async {
    Map<String, dynamic> notification = {
      'from': commentaire.user!.id,
      'to': commentaire.user!.id,
      'comment': commentaire.id,
      'type': 'comment.likeAPublicationcomment'
    };
    setState(() {
      isLiked = true;
    });
    await LikeService.ajouterLike(
            commentId: commentaire.id!, userId: DataController.user!.id!)
        .then((value) {
      print("status Code ${value.statusCode}");
      setState(() {
        commentaire.nbLikes = commentaire.nbLikes! + 1;
      });
      if (value.statusCode != 200) {
        setState(() {
          commentaire.nbLikes = commentaire.nbLikes! - 1;
          isLiked = false;
          //  isLiked(commentaire, DataController.user!.id!);
        });
      }
      if (value.statusCode == 200) {
        Map<String, dynamic> data = {
          "comment": commentaire.id!,
          "publication": widget.pubId,
          "inscremente": 0
        };
        print(data);
        // commentsocket!.socket!.emit("likeCommentEvent",{"comment":commentaire.id!,"publication":widget.pubId,"inscremente":0});

        commentsocket!.socket!.emit("likeCommentEvent", data);

        setState(() {
          likeId = jsonDecode(value.body)['_id'];
        });
        NotificationService.addNotification(notification);
        // notificationsocket!.
      }
    }).catchError((e) {
      setState(() {
        commentaire.nbLikes = commentaire.nbLikes! + 1;
        isLiked = true;
      });
      print("ERROR $e\n\n");
    });
  }

  // getNombreLike()async{
  //   await
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showActions = true;
        });
      },
      onTap: () {
        if (showActions == true) {
          setState(() {
            showActions = false;
          });
        }
      },
      child: Column(
        children: [
          Container(
              width: ScreenSize.width * 1,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                // border:Border.all(width: 1,color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                // color: Colors.black12
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsUser(user: commentaire.user!)));
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      margin: const EdgeInsets.only(right: 12),
                      child: ClipOval(
                          child: widget.com.user!.avatar!.isNotEmpty
                              ? Image.network(
                                  widget.com.user!.avatar!.first.url!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/medias/profile.jpg",
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    );
                                  },
                                )
                              : Image.asset("assets/medias/user.jpg",
                                  fit: BoxFit.cover)),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            // width: ScreenSize.width * 0.65,
                            // padding: EdgeInsets.all(8),

                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenSize.width * 0.65,
                              constraints: const BoxConstraints(
                                  // maxHeight: 90
                                  ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.com.user!.userName!,
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    widget.com.content!,
                                    style: GoogleFonts.roboto(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (showActions == false)
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DataController.FormatDate(
                                          date: widget.com.date!),
                                      style: GoogleFonts.roboto(fontSize: 9),
                                    ),
                                    const Spacer(),
                                    Container(
                                        child: Row(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.all(6),
                                            child: GestureDetector(
                                                onTap: () {
                                                  // likeCommentaire(com);
                                                },
                                                child: const Row(
                                                  children: [
                                                    // Text("J'aime",style: GoogleFonts.roboto(fontSize: 9,fontWeight:FontWeight.w500,color: isLiked(com, DataController.user!.id!)?Colors.blue:Colors.black)),
                                                  ],
                                                ))),
                                        // buttonReatComment('Repondre',(){}),
                                      ],
                                    )),
                                    const Spacer(),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  NumberFormat.compact().format(
                                                      widget.com.nbLikes),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  'Likes',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 9),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        )),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (likeId.isNotEmpty) {
                              setState(() {
                                isLiked = false;
                                commentaire.nbLikes = commentaire.nbLikes! - 1;
                              });
                              LikeService.removeLike(likeId).then((value) {
                                if (value.statusCode != 200) {
                                  // commentaire.nbLikes=commentaire.nbLikes!-1;
                                  setState(() {
                                    isLiked = false;
                                  });
                                }
                                if (value.statusCode == 200) {
                                  setState(() {
                                    likeId = '';
                                  });
                                }
                              }).catchError((e) {
                                print("ERROR $e");
                                setState(() {
                                  commentaire.nbLikes =
                                      commentaire.nbLikes! + 1;
                                  isLiked = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Verifier votre connexion')));
                              });
                            } else {
                              setState(() {
                                likeCommentaire(commentaire);
                              });
                            }
                          },
                          icon: Icon(
                            isLiked == false
                                ? Icons.favorite_border
                                : Icons.favorite_outlined,
                            size: 22,
                            color: isLiked ? Colors.red : null,
                          )),
                    ],
                  )
                ],
              )),
          if (showActions == false)
            const SizedBox(
              height: 12,
            ),
          if (showActions && commentaire.user!.id == DataController.user!.id!)
            WidgetActionCommentaire()
        ],
      ),
    );
  }

  Container WidgetActionCommentaire() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 68, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                dialogUpdate(commentaire);
              },
              icon: const Icon(
                Icons.edit,
                size: 18,
              )),
          IconButton(
              onPressed: () {
                dialogSuppression(commentaire);
              },
              icon: const Icon(
                Icons.delete,
                size: 18,
              ))
        ],
      ),
    );
  }

  dialogSuppression(Commentaire com) {
    bool waitDelete = false;
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, S) {
              return AlertDialog(
                title: Text(
                  "Suppression de commentaire",
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
                ),
                content: Text("Voulez-vous vraiment supprimer ce commentaire?",
                    style: GoogleFonts.roboto()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        S(() {
                          waitDelete = true;
                        });
                        CommentaireService.deleteCommentaire(id: com.id!)
                            .then((value) {
                          if (value.statusCode == 200) {
                            setState(() {
                              showActions = false;
                            });
                            widget.setState_(() {});
                            Navigator.pop(context);
                          }
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Un problème est survenu veuillez réessayer")));
                        });
                      },
                      child: !waitDelete
                          ? const Text("Confirmer")
                          : const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: couleurPrincipale,
                                strokeWidth: 1.5,
                              ),
                            )),
                ],
              );
            }));
  }

  dialogUpdate(Commentaire com) async {
    TextEditingController editController =
        TextEditingController(text: com.content);
    bool waitUpdate = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, S) {
            return AlertDialog(
              title: Text(
                "Modification de commentaire",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: Container(
                child: TextFormField(
                  controller: editController,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                      labelText: "Modifier le commentaire",
                      suffix: IconButton(
                          onPressed: () {
                            S(() {
                              waitUpdate = true;
                            });
                            if (editController.text.isNotEmpty) {
                              CommentaireService.updateCommentaire(
                                      id: com.id!, contenu: editController.text)
                                  .then((value) {
                                S(() {
                                  waitUpdate = false;
                                });
                                print(value.statusCode);
                                if (value.statusCode == 200) {
                                  widget.setState_(() {});
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Un problème est survenu")));
                                }
                              }).catchError((e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Un problème est survenu")));
                              });
                            }
                          },
                          icon: !waitUpdate
                              ? const Icon(Icons.send)
                              : const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: couleurPrincipale,
                                    strokeWidth: 1.5,
                                  ),
                                ))),
                ),
              ),
            );
          });
        });
  }
}
