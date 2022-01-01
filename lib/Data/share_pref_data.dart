import 'package:shared_preferences/shared_preferences.dart';

class SharedData{
  static getToken()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  static getId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }
}