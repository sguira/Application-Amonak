import 'dart:convert';

import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/auth.dart';
import 'package:application_amonak/prod.dart';
import 'package:application_amonak/services/socket/auth.dart';
import 'package:application_amonak/services/storage/authStorage.dart';
import 'package:http/http.dart' as http;
import 'package:application_amonak/models/user.dart';
class Login{

  static String server=apiLink+'/auths/login';

  static User? user;
  static Map<String,String> header={
    'Content-Type': 'application/json',
  };

  static Future<http.Response> authenticated(Auth auth)async{
    
    return await http.post(Uri.parse(server),body: jsonEncode(Auth.toJson(auth)), headers: {'Content-Type':'application/json'}).then((value) {
      print(value.body);
      if(int.parse(value.statusCode.toString())==200){
        DataController.user=User.fromJson(jsonDecode(value.body)['user']);
        tokenValue=Auth.logerToken(jsonDecode(value.body));
        AuthStorage.saveData("token", jsonDecode(value.body)['accessToken']);
        AuthStorage.saveData("userId", jsonDecode(value.body)["user"]["_id"]);

        AuthSocket authSocket=AuthSocket(
          path: "/amonak-api"
        );

        // authSocket.socket.emit()
      }
      
      return value;
    }).catchError((e){
      return e;
    });

  }
  static Future<http.Response> activateAccount(String code)async{
    return await http.get(Uri.parse("$apiLink/auths/activate/${int.parse(code)}")).then((value){
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> resendCode(String email)async{
    return await http.get(Uri.parse("$apiLink/auths/resend-activation-email/$email")).then((value){
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> checkToken(String token)async{
    return await http.get(Uri.parse("$apiLink/auths/check-token/$token")).then((value) {
      return value;
    }).catchError((e){
      return e;
    });
  }

  static Future<http.Response> requestResetPassword(String email)async{
    return await http.get(Uri.parse("$apiLink/auths/send-reset-password-requests/$email")).then((value){
      return value;
    }).catchError((e){
      print("ERROR $e");
      return e;
    });
  }

}