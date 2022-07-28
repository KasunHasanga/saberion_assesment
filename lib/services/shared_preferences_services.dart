library shared_preferences_service;
import 'package:shared_preferences/shared_preferences.dart';


Future getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token;
}

Future setToken(String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', data);
  return;
}

Future distroy() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  return;
}