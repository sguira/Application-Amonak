import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LocalStorage {
  static Future saveToken(String token) async {
    try {
      final ref = await SharedPreferences.getInstance();
      ref.setString("token", token);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future getToken() async {
    try {
      final ref = await SharedPreferences.getInstance();
      return ref.getString("token");
    } catch (e) {
      return null;
    }
  }

  static saveUserId(String id) async {
    try {
      final ref = await SharedPreferences.getInstance();
      ref.setString("userId", id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future removeData() async {
    try {
      final ref = await SharedPreferences.getInstance();
      ref.remove('token');
      ref.remove('timeout');
      ref.remove('userId');
      return true;
    } catch (e) {
      return null;
    }
  }

  static Future getUserId() async {
    try {
      final ref = await SharedPreferences.getInstance();
      return ref.getString("userId");
    } catch (e) {
      return false;
    }
  }

  static saveTokenTimeout(int timeout) async {
    try {
      final ref = await SharedPreferences.getInstance();
      String date = DateTime.now().add(Duration(seconds: timeout)).toString();
      ref.setString("timeout", date);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future getDateTokenTimeout() async {
    try {
      final ref = await SharedPreferences.getInstance();

      return ref.getString("timeout");
    } catch (e) {
      return null;
    }
  }
}
