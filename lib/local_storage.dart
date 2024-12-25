
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorage{
  static Future saveToken(String token)async{
    try{
      final ref=await SharedPreferences.getInstance();
      ref.setString("token", token);
      return true;
    }
    catch(e){
      return false;
    }

  }

  static Future getToken()async{
    try{
      final ref=await SharedPreferences.getInstance();
      return ref.getString("token");
    }
    catch(e){
      return null;
    }
  }

  static saveUserId(String id)async{
    try{
      final ref=await SharedPreferences.getInstance();
      ref.setString("userId", id);
      return true;
    }
    catch(e){
      return false;
    }
  }
  static getUserId()async{
    try{
      final ref=await SharedPreferences.getInstance();
      return ref.getString("userId");
    }
    catch(e){
      return false;
    }
  }
}