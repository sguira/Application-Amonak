import 'package:application_amonak/models/adresse.dart';
import 'file.dart';
class User{
  String? email; 
  // String? passWord; 
  String? id; 
  String? gender;
  String? password;
  String? userName;
  List<String>? profession = [];
  List<String?>? sectors = [];
  List<String>? webSites = [];
  List<Address>? address = [];
  List<String>? friends = [];
  List<String>? followers = [];
  bool? status;
  String? accountType;
  bool? isLog;
  bool? isFirstTime;
  bool? isNewFeed;
  String? firstName;
  String? lastName;
  String? phone;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Files>? avatar;
  int? iV;

    User(
      {this.id,
      this.userName,
      this.email,
      this.password,
      this.gender,
      this.profession,
      this.sectors,
      this.webSites,
      this.address,
      this.friends,
      this.followers,
      this.status,
      this.firstName,
      this.lastName,
      this.phone,
      this.accountType,
      this.isLog,
      this.isFirstTime,
      this.isNewFeed,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.avatar,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    firstName = json['firstName'];
    phone = json['phone'];
    lastName = json['lastName'];
    description = json['description'];
    friends = json['friends']?.cast<String>();
    followers = json['followers']?.cast<String>();
    profession = json['profession']?.cast<String>();
    sectors = json['sectors']?.cast<String?>();
    webSites = json['webSites']?.cast<String>();
  
    if (json['avatar'] != null) {
      avatar = [];
      json['avatar'].forEach((v) {
        avatar!.add(Files.fromJson(v));
      });
    } else {
      avatar = [
        Files(
            url:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/660px-No-Image-Placeholder.svg.png?20200912122019')
      ];
    }

    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(Address.fromJson(v));
      });
    }
    status = json['status'];
    accountType = json['accountType'];
    isLog = json['isLog'];
    isFirstTime = json['isFirstTime'];
    isNewFeed = json['isNewFeed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['gender'] = gender;
    data['profession'] = profession;
    data['friends'] = friends;
    data['followers'] = followers;
    data['sectors'] = sectors;
    data['webSites'] = webSites;
    data['description'] = description;

    if (avatar != null) {
      data['avatar'] = avatar!.map((v) => v.toJson()).toList();
    }

    data['phone'] = phone;
    data['lastName'] = lastName;
    data['firstName'] = lastName;

    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }

    data['status'] = status;
    data['accountType'] = accountType;
    data['isLog'] = isLog;
    data['isFirstTime'] = isFirstTime;
    data['isNewFeed'] = isNewFeed;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }

  Map<String,dynamic> toJson2(){
    return {
      'email':email, 
      'password':password, 
      'userName':userName
      
    };
  }

  afficherUser(){
    print("Utilisateur".toUpperCase());
    print("----------------------");
    print("Nom: ${firstName}\tEmail:${email}\tPassword:${password} LastName:$lastName");
  }

}