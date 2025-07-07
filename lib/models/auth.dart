class Auth{

  String? userName;
  String? passWord;
  
  Auth({
    this.userName, 
    this.passWord
  });

  static toJson(Auth auth){
    return {
      'email':auth.userName, 
      'password':auth.passWord
    };
  }

  static logerToken(dynamic map ){
    return map['accessToken'];
  }
}