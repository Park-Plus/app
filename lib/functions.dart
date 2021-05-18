import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> handleLogin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token");
  var r = await http.get(
    Uri.parse("http://10.0.2.2:8252/auth/me"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  if(r.statusCode == 401){
    String newToken = await renewToken(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(newToken != "-"){
      prefs.setString("access_token", newToken);
    }else{
      prefs.setBool("logged_in", false);
      prefs.remove("access_token");
      return false;
    }
  }
  return true;
}

Future<String> renewToken(String oldToken) async{
  var r = await http.post(
  Uri.parse("http://10.0.2.2:8252/auth/refresh"),
    headers: {
      'Authorization': 'Bearer ' + oldToken
    }
  );
  if(r.statusCode == 200){
    print("Token rinnovato.");
    return jsonDecode(r.body)['access_token'];
  }else{
    return '-';
  }
}

Future<dynamic> getUsersInfo() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token");
  var r = await http.get(
    Uri.parse("http://10.0.2.2:8252/auth/me"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> getVehicles() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse("http://10.0.2.2:8252/user/vehicles/list"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  print(r.body);
  return jsonDecode(r.body);
}
