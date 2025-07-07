import 'package:shared_preferences/shared_preferences.dart';
class AuthStorage{

  static saveData(String key,String value)async{
    final ref=await SharedPreferences.getInstance();
    try{
      
      ref.setString(key, value);
    }
    catch(e){
      print(e);
    }
  }

  static Future<dynamic> getValue(String key)async{
    try{
      final ref=await SharedPreferences.getInstance();
      return ref.getString(key);
    }
    catch(e){
      print(e);
      return null;
    }
  }

}