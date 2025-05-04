import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:application_amonak/colors/colors.dart';
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/interface/explorer/details_user.dart';
import 'package:application_amonak/models/message.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/message.dart';
import 'package:application_amonak/services/socket/chatProvider.dart';
import 'package:application_amonak/services/user.dart';
import 'package:application_amonak/settings/weights.dart';
import 'package:application_amonak/widgets/buildModalSheet.dart';
import 'package:application_amonak/widgets/wait_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagePage extends StatefulWidget {
  final User user;
  const MessagePage({super.key, required this.user});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController message = TextEditingController();

  bool waitingSend = false;
  List<MessageModel> listMessage = [];
  User? from;

  bool showAction = false;
  int? currentsate;

  bool showListen = true;
  bool waitDelete = false;

  final imagePicker = ImagePicker();
  XFile? file;
  File? fileSelected;
  ScrollController scrollController = ScrollController();
  late MessageSocket messageSocket;

  String room = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // loadUser();
    messageSocket = MessageSocket();

    //join chat room
    messageSocket.socket!.emit("joinChatRoom",
        {"from": DataController.user!.id, "to": widget.user.id});
    messageSocket.socket!.on("joinedChatRoom", (handler) {
      print("joined chat $handler");
      room = handler;
    });

    /*
      Apporter une correction au server faire en sorte que le socket renvoie également le message
      au lieux d'envoyé juste le from
    */
    messageSocket.socket!.on("refreshMessageBoxHandler", (handler) {
      print("message recu $handler ");
      if (handler['to'] == DataController.user!.id) {
        setState(() {
          loadMessage();
        });
      }
    });
    loadMessage();
    // scrollController=ScrollController(
    //   initialScrollOffset: scrollController.position.maxScrollExtent??200
    // );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        Duration(seconds: 5), 
       
      );  
       scrollJump();
    });
  }

  scrollJump()async {
    await Future.delayed(
      Duration(seconds: 3)
    );
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // ou pour un scroll animé :
    // scrollController.animateTo(
    //   scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  @override
  void dispose() {
    messageSocket.socket!.close();
    super.dispose();
  }

  loadUser() async {
    return await UserService.getUser(userId: widget.user.id!).then((value) {
      if (value.statusCode == 200) {
        from = User.fromJson(jsonDecode(value.body));
      }
    }).catchError((e) {
      print(e);
    });
  }

  loadMessage() async {
    return await MessageService.getMessage(
            params: {'to': DataController.user!.id, 'from': widget.user.id})
        .then((value) async {
      // print("valueeee ss ${value.body}");
      if (value.statusCode == 200) {
        listMessage = [];
        for (var item in jsonDecode(value.body) as List) {
          if (item['to'] != null && item['from'] != null) {
            // print(item);
            try {
              setState(() {
                listMessage.add(MessageModel.fromJson(item));
              });
            } catch (e) {
              print("Une erreur est survenue $e \n ${item['content']}");
            }
          }
          print("itemmmm $item");
        }
        
      }
      await loadUser();
      setState(() {
        showListen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 70,
      //   titleSpacing: 12,
      //   title:
      // ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            showAction = false;
          });
        },
        child: Container(
          child: Column(
            children: [
              headerMessage(),
              Expanded(
                  child: showListen == false
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: listMessage.length,
                          itemBuilder: (contxt, index) {
                            return GestureDetector(
                              onTap: () {
                                if (listMessage[index].iSend) {
                                  setState(() {
                                    showAction = !showAction;
                                    currentsate = index;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: listMessage[index].iSend
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 16, right: 8, left: 22),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: !listMessage[index].iSend
                                                      ? couleurPrincipale
                                                          .withAlpha(40)
                                                      : const Color.fromARGB(255, 88, 77, 77)
                                                          .withAlpha(20),
                                                  // border:Border.all(color: couleurPrincipale.withAlpha(100),width: 0.5),
                                                  borderRadius: listMessage[index].iSend
                                                      ? const BorderRadius.only(
                                                          topLeft: Radius.circular(
                                                              26),
                                                          topRight: Radius.circular(
                                                              5),
                                                          bottomLeft: Radius
                                                              .circular(5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))
                                                      : const BorderRadius.only(
                                                          topRight: Radius.circular(26),
                                                          bottomLeft: Radius.circular(5),
                                                          bottomRight: Radius.circular(5),
                                                          topLeft: Radius.circular(5))),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 200),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listMessage[index].iSend
                                                          ? DataController
                                                              .user!.userName!
                                                          : from!.userName!,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      listMessage[index]
                                                          .content,
                                                      style:
                                                          GoogleFonts.roboto(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (listMessage[index]
                                                .files
                                                .isNotEmpty)
                                              Container(
                                                // height: 120,
                                                // width: 80,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        ScreenSize.width * 0.4),
                                                // color: Colors.black12,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11),
                                                    child: Image.network(
                                                        listMessage[index]
                                                            .files
                                                            .first
                                                            .url!,errorBuilder: (context, error, stackTrace) {
                                                            return Image.asset(
                                                                "assets/medias/profile.jpg",
                                                                fit: BoxFit.cover,
                                                                width: 48,
                                                                height: 48,
                                                              );
                                                          },)),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (currentsate == index &&
                                          showAction &&
                                          listMessage[index].iSend)
                                        Animate(
                                          effects: const [
                                            SlideEffect(
                                                begin: Offset(1, 0),
                                                end: Offset(0, 0),
                                                duration:
                                                    Duration(milliseconds: 100))
                                          ],
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 16),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      dialogEdit(index);
                                                    },
                                                    icon: const Icon(Icons.edit,
                                                        size: 18)),
                                                IconButton(
                                                    onPressed: () {
                                                      dialogDeleteMessage(
                                                          index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        size: 18)),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const SpinKitWaveSpinner(
                          color: couleurPrincipale,
                        )),
              StatefulBuilder(builder: (context, setState_) {
                return Container(
                  // height: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (fileSelected != null)
                        FileSelectedViewer(
                          file: fileSelected!,
                          onClose: onCloseFile,
                        ),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                // height: 58,
                                // padding: EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(36)),
                                // alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        pickeImage();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        // color: Colors.black,
                                        // margin:const EdgeInsets.only(top: 36,right: 12),
                                        child: const Icon(
                                          Icons.attach_file,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        // margin:const EdgeInsets.only(top: 8,left: 12),
                                        margin: const EdgeInsets.only(
                                            left: 8, bottom: 8, top: 6),
                                        child: TextFormField(
                                          controller: message,
                                          // maxLines: 5,
                                          style:
                                              GoogleFonts.roboto(fontSize: 14),

                                          autofocus: true,
                                          maxLines: 5,
                                          minLines: 1,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            // suffix:
                                            // contentPadding:const EdgeInsets.only(top: 44,left: 18,right: 12),
                                            // contentPadding:const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                                            hintText: 'Ecrire ...',

                                            // filled: true,
                                            // fillColor: Colors.black12,

                                            hintStyle: GoogleFonts.roboto(
                                                fontSize: 13),
                                            border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    buttonSend(setState_),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Container buttonSend(StateSetter setState_) {
    return Container(
        // margin:const EdgeInsets.only(top: 12),
        child: IconButton(
      icon: !waitingSend
          ? const Column(
              children: [
                Icon(
                  Icons.send,
                  size: 18,
                ),
                // Text('Envoyer',style: GoogleFonts.roboto(fontSize: 9),)
              ],
            )
          : Container(
              // margin:const EdgeInsets.only(bottom: 16),
              child: const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            ),
      onPressed: () {
        sendMessage(setState_);
      },
    ));
  }

  onCloseFile() {
    setState(() {
      fileSelected = null;
    });
  }

  dialogEdit(int index) {
    TextEditingController editMessage =
        TextEditingController(text: listMessage[index].content);
    bool waitUpdate = false;
    return showCustomModalSheetWidget(
        context: context,
        child: StatefulBuilder(builder: (context, S) {
              return Container(
                height: 120,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: ListView(
                  children: [
                    Text(
                      "Modification de message",
                      style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 58,
                      margin: const EdgeInsets.only(top: 28),
                      child: TextFormField(
                        controller: editMessage,
                        // maxLines: 7,
                        minLines: 1,
                        autofocus: true,
                        decoration: InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                                borderRadius: BorderRadius.circular(36)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                                borderRadius: BorderRadius.circular(36)),
                            // labelText: 'Modifier le message',
                            suffix: IconButton(
                                onPressed: () {
                                  if (editMessage.text.isNotEmpty) {
                                    MessageService.modifierMessage(
                                            messageId: listMessage[index].id,
                                            data: {'content': editMessage.text})
                                        .then((value) {
                                      if (value.statusCode == 200) {
                                        setState(() {});
                                      }
                                    }).catchError((e) {});
                                  }
                                },
                                icon: const Icon(Icons.send))),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  dialogDeleteMessage(int index) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, S) {
              return AlertDialog(
                  title: Text("Supprimer le message",
                      style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                  content: const Text("Voulez-vous supprimer ce message ?"),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Non"),
                    ),
                    TextButton(
                        onPressed: () {
                          S(() {
                            waitDelete == true;
                          });
                          MessageService.deleteMessage(
                                  id: listMessage[index].id)
                              .then((value) {
                            print(value.statusCode);
                            if (value.statusCode == 500) {
                              setState(() {
                                listMessage.removeAt(index);
                                Navigator.pop(context);
                                showAction = false;
                              });
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Un problème est survenu")));
                            }
                          }).catchError((e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Un problème est survenu")));
                          });
                        },
                        child: waitDelete == false
                            ? const Text("Oui")
                            : const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: couleurPrincipale,
                                  strokeWidth: 2,
                                ),
                              ))
                  ]);
            }));
  }

  pickeImage() async {
    file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        fileSelected = File(file!.path);
      });
    }
  }

  sendMessage(dynamic setState_) {
    if (message.text != '') {
      setState_(() {
        waitingSend = true;
      });
      MessageModel messageModel = MessageModel();
      messageModel.from = DataController.user!;
      messageModel.to = widget.user;
      messageModel.content = message.text;
      MessageService.sendMessage(message: messageModel, file: fileSelected)
          .then((value) {
        setState_(() {
          waitingSend = false;
        });
        if (value.statusCode == 200) {
          // socket!.emit("sendMessage",)
          messageSocket.socket!.emit(
              "sendMessage", {"room": room, "message": jsonDecode(value.body)});
          messageSocket.socket!.emit("refreshMessageBox",
              {"to": widget.user.id, "from": DataController.user!.id});
          setState(() {
            fileSelected = null;
          });
          setState(() {
            listMessage.add(MessageModel.fromJson(jsonDecode(value.body)));
          });
        }
      }).catchError((e) {
        setState_(() {
          waitingSend = false;
        });
        print(e);
      });
    }
    // else{
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer un message',style: GoogleFonts.roboto(),)));
    // }
  }

  Padding headerMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsUser(user: widget.user) ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     width: 1,
          //     color: couleurPrincipale.
          //   )
          // ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 50,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: couleurPrincipale),
                      borderRadius: BorderRadius.circular(36)),
                  child: ClipOval(
                      child: Image.asset(
                    "assets/medias/profile.jpg",
                    width: 40,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(widget.user.userName!.toUpperCase(),
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w800)),
              ),
              const Spacer(),
              Container(
                child: IconButton(
                    onPressed: () {
                      messageSocket.socket!.emit("leaveChatRoom", {});
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FileSelectedViewer extends StatefulWidget {
  final File file;
  final dynamic onClose;
  final String? type;
  const FileSelectedViewer(
      {super.key, required this.file, required this.onClose, this.type});

  @override
  State<FileSelectedViewer> createState() => _FileSelectedViewerState();
}

class _FileSelectedViewerState extends State<FileSelectedViewer> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == 'video') {
      videoController = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          videoController.setLooping(true);
          videoController.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (widget.type == 'video') {
      videoController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: couleurPrincipale),
          borderRadius: BorderRadius.circular(16)),
      width: 90,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              // width: 90,
              // height: 90,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.type != 'video'
                      ? Image.file(
                          widget.file,
                          fit: BoxFit.cover,
                        )
                      : videoController.value.isInitialized
                          ? VideoPlayer(videoController)
                          : const Center(
                              child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: couleurPrincipale,
                              ),
                            ))),
            ),
          ),
          Center(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(16)),
                child: IconButton(
                    onPressed: () {
                      widget.onClose();
                    },
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.white))),
          )
        ],
      ),
    );
  }
}
