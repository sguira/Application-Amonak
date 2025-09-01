import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/connection/activation.dart';
import 'package:application_amonak/interface/boutique/details_boutique..dart';
import 'package:application_amonak/interface/publication/publication.dart';
import 'package:application_amonak/interface/profile/edit_profile.dart';
import 'package:application_amonak/interface/profile/gestion_profile.dart';
import 'package:application_amonak/interface/profile/list_abonne.dart';
import 'package:application_amonak/interface/profile/list_achat.dart';
import 'package:application_amonak/interface/profile/publication_widget.dart';
import 'package:application_amonak/models/article.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/services/product.dart';
import 'package:application_amonak/services/profil.dart';
import 'package:application_amonak/services/publication.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/list_friend_widget.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedFile;
  final _picker = ImagePicker();
  List<User> users = [];
  List<ArticleModel> articles = [];
  List<Publication> publications = [];
  List<Publication> alertes = [];

  Future<void>? initData;

  //tailles
  int nbArticles = 0;
  int nbPublications = 0;
  int nbAlertes = 0;
  int nbAbonnes = 0;

  Future<void> getPublications() async {
    await PublicationService.getPublications(userId: DataController.user!.id!)
        .then((value) {
      if (value.statusCode == 200) {
        publications = [];
        for (var item in jsonDecode(value.body)) {
          publications.add(Publication.fromJson(item));
        }
        setState(() {
          nbPublications = publications.length;
        });
      }
    }).catchError((e) {
      print("une erreeeeur est survenue \n\n ${e.toString()} ");
    });
  }

  Future<void> getAlertes() async {
    await PublicationService.getPublications(
            userId: DataController.user!.id!, type: 'alerte')
        .then((value) {
      if (value.statusCode == 200) {
        alertes = [];
        for (var item in jsonDecode(value.body)) {
          alertes.add(Publication.fromJson(item));
        }
        setState(() {
          nbAlertes = alertes.length;
        });
      }
    }).catchError((e) {
      print("une erreeeeur est survenue \n\n ${e.toString()} ");
    });
  }

  //liste des articles
  Future<void> getArticles() async {
    await ProductService.getSingleArticle(userId: DataController.user!.id!)
        .then((value) {
      if (value.statusCode == 200) {
        articles = [];
        for (var item in jsonDecode(value.body)) {
          try {
            articles.add(ArticleModel.fromJson(item)!);
          } catch (e) {
            print(e);
          }
        }
        setState(() {
          nbArticles = articles.length;
        });
      }
    }).catchError((e) {
      print("une erreeeeur est survenue \n\n ${e.toString()} ");
    });
  }

  Future<void> getData() async {
    await [
      getArticles(),
      getAlertes(),
      getPublications(),
      listRequestFriend(),
    ];
  }

  Future<void> listRequestFriend() async {
    await UserService.getAllUser(param: {
      "friendRequest": true.toString(),
      "user": DataController.user!.id,

      // "friend":true
    }).then((value) {
      if (value.statusCode == 200) {
        users = [];
        print("status code eee:${value.statusCode} ");
        for (var item in jsonDecode(value.body)) {
          users.add(User.fromJson(item));
        }
      }
    }).catchError((e) {
      print("une erreeeeur est survenue \n\n ${e.toString()} ");
    });
  }

  @override
  void initState() {
    super.initState();
    initData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GestionProfilePage()));
                  },
                  child: Text(
                    'Gerer',
                    style: GoogleFonts.roboto(
                        decoration: TextDecoration.underline,
                        color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()));
                  },
                  child: Text(
                    'Editer',
                    style: GoogleFonts.roboto(
                        decoration: TextDecoration.underline,
                        color: Colors.black),
                  ))
            ],
          ),
        ),
        // body: tabBarContainer(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 280,
                // pinned: true,
                floating: true,
                // pinned: true,
                flexibleSpace: FlexibleSpaceBar(background: headerProfile()),
              )
            ];
          },
          body: tabBarContainer(),
        ));
  }

  Widget tabBarContainer() {
    return FutureBuilder(
        future: initData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitWidget();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Une erreur est survenue",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.red),
              ),
            );
          }

          return Container(
            child: Column(
              children: [
                // headerProfile(),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 4,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 0,
                        bottom: TabBar(
                          tabs: [
                            itemTab('articles', nbArticles),
                            itemTab('publications', nbPublications),
                            itemTab('alertes', nbAlertes),
                            itemTab('abonnés', users.length),
                          ],
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: couleurPrincipale,
                        ),
                      ),
                      body: TabBarView(clipBehavior: Clip.hardEdge, children: [
                        FutureListArticle(userId: DataController.user!.id!),
                        PublicationPage(
                          type: 'default',
                          userId: DataController.user!.id,
                          hideLabel: true,
                        ),
                        PublicationPage(
                          type: 'alerte',
                          userId: DataController.user!.id,
                          hideLabel: true,
                        ),
                        FutureBuilder(
                            future: listRequestFriend(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          child: ContainerFollowerWidget(
                                              users: users)),
                                    ],
                                  ));
                            })
                      ]),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Tab itemTab(String label, int value) {
    return Tab(
      // height: 40,
      child: Column(
        children: [
          Text(
            NumberFormat.compact(locale: 'fr').format(value),
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: couleurPrincipale,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.roboto(fontSize: 8, color: couleurPrincipale),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Column headerProfile() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 1,),
            GestureDetector(
              onTap: () {
                showEditPicture();
              },
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(56),
                    border: Border.all(width: 2, color: couleurPrincipale)),
                margin: const EdgeInsets.symmetric(vertical: 22),
                child: ClipOval(
                  child: DataController.user!.avatar!.isNotEmpty
                      ? Image.network(
                          DataController.user!.avatar![0].url!,
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
                          fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Text(DataController.user!.userName!.toUpperCase(),
              style: GoogleFonts.roboto(
                  fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 3)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 22),
          child: Text(
            DataController.user!.description ?? 'Aucune Description',
            style: GoogleFonts.roboto(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 120,
          child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ListAchat()));
              },
              style: TextButton.styleFrom(
                  backgroundColor: couleurPrincipale.withAlpha(32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_checkout),
                  const SizedBox(width: 4),
                  Text("Mes achats", style: GoogleFonts.roboto(fontSize: 13))
                ],
              )),
        )
      ],
    );
  }

  showEditPicture() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                margin: const EdgeInsets.symmetric(horizontal: 76),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: 120,
                decoration: BoxDecoration(
                    color: couleurPrincipale,
                    borderRadius: BorderRadius.circular(66)),
                constraints:
                    const BoxConstraints(maxWidth: 100, maxHeight: 240),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                viewPicture();
                              },
                              icon: const Icon(
                                FontAwesomeIcons.eye,
                                size: 18,
                                color: Colors.white,
                              )),
                          Text(
                            'Voir',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 9),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                choiceFile('image');
                                // if(selectedFile!=null){
                                //   confirmerModificationPhoto();
                                // }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.camera,
                                size: 18,
                                color: Colors.white,
                              )),
                          Text(
                            'Modifier',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 9),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                FontAwesomeIcons.x,
                                size: 18,
                                color: Colors.white,
                              )),
                          Text(
                            'Fermer',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 9),
                          )
                        ],
                      ),
                    ),
                    // Divider(color: Colors.white,)
                  ],
                ),
              ),
            ));
  }

  confirmerModificationPhoto() {
    bool wait = false;
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState_) {
              return AlertDialog(
                content: Container(child: Image.file(selectedFile!)),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        setState_(() {
                          wait = true;
                        });

                        ProfilService.updatePictureProfile(selectedFile!)
                            .then((value) {
                          setState_(() {
                            wait = false;
                          });
                          if (value == "OK") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Photo modifié")));
                            Navigator.pop(context);
                            setState(() {
                              DataController.user = DataController.user!;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Une erreur est survenue")));
                          }
                        }).catchError((e) {
                          print(e);
                          setState_(() {
                            wait = false;
                          });
                        });
                      },
                      child: !wait
                          ? const Text("Confirmer")
                          : const ButtonProgress(
                              color_: couleurPrincipale,
                            ))
                ],
              );
            }));
  }

  modifierAvatar() {}

  viewPicture() {
    Navigator.pop(context);
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        showDragHandle: true,
        useSafeArea: false,
        builder: (context) => Container(
              child: DataController.user!.avatar!.isEmpty
                  ? Image.asset(
                      "assets/medias/user.jpg",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      DataController.user!.avatar!.first.url!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/medias/profile.jpg",
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                        );
                      },
                    ),
            ));
  }

  header() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(color: Colors.red),
    );
  }

  choiceFile(String type) async {
    Navigator.pop(context);
    final XFile? file;

    if (type == 'image') {
      file = await _picker.pickImage(source: ImageSource.gallery);
      print("nom de fichier ${file!.path}");
    } else {
      file = await _picker.pickVideo(source: ImageSource.gallery);
    }
    if (file != null) {
      setState(() {
        selectedFile = File(file!.path);
        print("File ok");
      });
    }

    if (selectedFile != null) {
      confirmerModificationPhoto();
    }
  }
}

class FutureListArticle extends StatelessWidget {
  final String userId;
  FutureListArticle({super.key, required this.userId});

  List<ArticleModel> articles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ProductService.getSingleArticle(userId: userId).then((value) {
            if (value.statusCode.toString() == '200') {
              articles = [];
              for (var item in jsonDecode(value.body) as List) {
                try {
                  articles.add(ArticleModel.fromJson(item)!);
                } catch (e) {
                  print(e);
                }
              }
            }
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WaitWidget();
            }
            if (snapshot.hasError) {
              return const Text("Une erreur est survenue");
            }
            return ListArticle(articleModel: articles);
          }),
    );
  }
}
