import 'package:application_amonak/models/notifications.dart';
import 'package:application_amonak/models/publication.dart';
import 'package:application_amonak/models/user.dart';
import 'package:video_player/video_player.dart';

class DataController {
  static List publications = [
    {
      'userIcon': 'assets/medias/user.jpg',
      'userName': 'Fabrice DIANE',
      'nbLike': 75200,
      'nbCommentaires': 2500,
      'pubImage': 'assets/medias/articles/article2.jpg',
      'partages': 90,
      'description': """
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """,
    },
    {
      'userIcon': 'assets/medias/user.jpg',
      'userName': 'Fabrice DIANE',
      'nbLike': 75200,
      'nbCommentaires': 2500,
      'pubImage': 'assets/medias/articles/article1.jpg',
      'partages': 90,
      'description': """
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """,
    },
    {
      'userIcon': 'assets/medias/user.jpg',
      'userName': 'Fabrice DIANE',
      'nbLike': 75200,
      'nbCommentaires': 2500,
      'pubImage': 'assets/medias/articles/article3.jpg',
      'partages': 90,
      'description': """
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """,
    },
    {
      'userIcon': 'assets/medias/user.jpg',
      'userName': 'Fabrice DIANE',
      'nbLike': 75200,
      'nbCommentaires': 2500,
      'pubImage': 'assets/medias/airpods.jpg',
      'partages': 90,
      'description': """
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """,
    }
  ];

  static List articles = [
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article1.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article2.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article6.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article4.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article5.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article6.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article5.jpg',
      'description': 'mes articles '
    },
    {
      'name': 'Article 1',
      'image': 'assets/medias/articles/article6.jpg',
      'description': 'mes articles '
    }
  ];

  static User? user;

  static Map<String, VideoPlayerController> videoPlayerControllers = {};

  static List videoControllerHistory = [];
  static List<Publication> videos = [];
  static String searchQuery = "";

  static List<NotificationModel> notifications = [];
  static int notificationCount = 0;
  static List<User> friends = [];

  static checVideoExist(String id) {
    if (videoControllerHistory.isNotEmpty) {
      for (int i = 0; i < videoControllerHistory.length; i++) {
        if (videoControllerHistory[i]['id'] == id) {
          return videoControllerHistory[i];
        }
      }
    }
    return null;
  }

  static addVideoToHistory(String id, VideoPlayerController controller) {
    if (videoControllerHistory.isNotEmpty) {
      for (int i = 0; i < videoControllerHistory.length; i++) {
        if (videoControllerHistory[i]['id'] == id) {
          videoControllerHistory[i]['controller'] = controller;
          return;
        }
      }
    }
    videoControllerHistory.add({'id': id, 'controller': controller});
  }

  static removeVideoFromHistory(String id) {
    if (videoControllerHistory.isNotEmpty) {
      for (int i = 0; i < videoControllerHistory.length; i++) {
        if (videoControllerHistory[i]['id'] == id) {
          videoControllerHistory.removeAt(i);
          return;
        }
      }
    }
  }

  static VideoPlayerController? getVideoControllerById(String id) {
    if (videoControllerHistory.isNotEmpty) {
      for (int i = 0; i < videoControllerHistory.length; i++) {
        if (videoControllerHistory[i]['id'] == id) {
          return videoControllerHistory[i]['controller'];
        }
      }
    }
    return null;
  }

  static FormatDate({required DateTime date}) {
    DateTime now = DateTime.now();
    int seconds = now.difference(date).inSeconds;
    if (seconds < 60) {
      return "$seconds s";
    } else if (seconds < 3600) {
      return "${(seconds / 60).round()} m";
    } else if (seconds < 86400) {
      return "${(seconds / 3600).round()} h";
    } else if (seconds < 2592000) {
      // moins de 30 jours
      return "${(seconds / 86400).round()} j";
    } else if (seconds < 31536000) {
      // moins d'un an
      return "${(seconds / 2592000).round()} mois";
    } else {
      return "${(seconds / 31536000).round()} an${(seconds / 31536000).round() > 1 ? 's' : ''}";
    }
  }
}
