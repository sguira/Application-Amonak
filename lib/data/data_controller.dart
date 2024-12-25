import 'package:application_amonak/models/user.dart';
class DataController{

  static List publications=[
    {
      'userIcon':'assets/medias/user.jpg',
      'userName':'Fabrice DIANE',
      'nbLike':75200, 
      'nbCommentaires':2500,
      'pubImage':'assets/medias/articles/article2.jpg',
      'partages':90, 
      'description':"""
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """, 

    }, 
    {
      'userIcon':'assets/medias/user.jpg',
      'userName':'Fabrice DIANE',
      'nbLike':75200, 
      'nbCommentaires':2500, 
      'pubImage':'assets/medias/articles/article1.jpg',
      'partages':90, 
      'description':"""
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """, 

    }, 
    {
      'userIcon':'assets/medias/user.jpg',
      'userName':'Fabrice DIANE',
      'nbLike':75200, 
      'nbCommentaires':2500,
      'pubImage':'assets/medias/articles/article3.jpg', 
      'partages':90, 
      'description':"""
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """, 

    }, 
    {
      'userIcon':'assets/medias/user.jpg',
      'userName':'Fabrice DIANE',
      'nbLike':75200, 
      'nbCommentaires':2500,
      'pubImage':'assets/medias/airpods.jpg', 
      'partages':90, 
      'description':"""
        Ces derniers jours, j'ai remarqué quelque chose d'étrange avec mes AirPods Pro. Alors que je suis en pleine partie de mon jeu vidéo préféré, un coup de fil arrive et les AirPods se déconnectent de mon iPhone pour se connecter automatiquement à mon iPad qui est à l'autre bout de la pièce !
        C'est comme s'ils avaient une vie propre !  Quelqu'un d'autre a déjà vécu ça ? #AirPodsPro #bug #connexion #aideApple
      """, 

    }
  ];


  static List articles=[
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article1.jpg', 
      'description':'mes articles '
    }, 
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article2.jpg', 
      'description':'mes articles '
    },
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article6.jpg', 
      'description':'mes articles '
    },
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article4.jpg', 
      'description':'mes articles '
    }, 
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article5.jpg', 
      'description':'mes articles '
    }, 
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article6.jpg', 
      'description':'mes articles '
    }, 
     
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article5.jpg', 
      'description':'mes articles '
    }, 
    {
      'name':'Article 1', 
      'image':'assets/medias/articles/article6.jpg', 
      'description':'mes articles '
    }
  ];

  static List videos=[
    {
      'path':'assets/videos/background1.mp4', 
      'isLike':false, 
      'isComment':true, 
      'isShare':true, 
      'nbLike':0, 
      'nbComment':10, 
      'nbShare':20, 
      'description':'Vente de cadre'
    }, 
    {
      'path':'assets/videos/airpods2.mp4', 
      'isLike':false, 
      'isComment':false, 
      'isShare':false, 
      'nbLike':10000, 
      'nbComment':10000, 
      'nbShare':700, 
      'description':'La vie est une aventure, chaque jour est une nouvelle page à écrire. Tu es plus forte que tu ne le penses. Crois en toi et fais briller ton éclat.'
    }, 
    {
      'path':'assets/videos/airpods2.mp4', 
      'isLike':true, 
      'isComment':true, 
      'isShare':true,
      'nbLike':7000, 
      'nbComment':10000, 
      'nbShare':700, 
      'description':'La vie est une aventure, chaque jour est une nouvelle page à écrire. Tu es plus forte que tu ne le penses. Crois en toi et fais briller ton éclat.'
    }, 
    {
      'path':'assets/videos/airpods3.mp4', 
      'isLike':true, 
      'isComment':true, 
      'isShare':true, 
      'nbLike':7000, 
      'nbComment':10000, 
      'nbShare':700, 
      'description':'La vie est une aventure, chaque jour est une nouvelle page à écrire. Tu es plus forte que tu ne le penses. Crois en toi et fais briller ton éclat.'
    }
  ];


  static User? user;

  static List videoControllerHistory=[];

  

  static List<Map<String,String>> personnes=[
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg',
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }
    , 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }
    , 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }, 
    {
      'profil':'assets/medias/user.jpg', 
      'name':'Guira'
    }
  ];

  static likeVideo(int index){
    videos[index]['isLike']=!videos[index]['isLike'];
    videos[index]['nbLike']=videos[index]['nbLike']+1;
  }

  static checVideoExist(String id){
    if(videoControllerHistory.isNotEmpty){
      for(int i=0;i<videoControllerHistory.length;i++){
        if(videoControllerHistory[i]['id']==id){
          return videoControllerHistory[i];
        }
      }
    }
    return null;
  }

}