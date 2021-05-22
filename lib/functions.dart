import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = "http://10.0.2.2:8252";

/*
  Local development: http://10.0.2.2:8252
  Production: https://api.parkplus.cc
*/

Future<bool> login(String mail, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map data = {
    'email': mail,
    'password': password
  };
  var r = await http.post(
    Uri.parse(baseUrl + "/auth/login"),
    body: data
  );
  if(r.statusCode == 200){
    dynamic js = jsonDecode(r.body);
    prefs.setBool('logged_in', true);
    prefs.setString('access_token', js["access_token"]);
    return true;
  }
  else{
    return false;
  }
}

Future<bool> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token");
  var r = await http.post(
    Uri.parse(baseUrl + "/auth/logout"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  if(r.statusCode == 200){
    prefs.remove('logged_in');
    prefs.remove('access_token');
    return true;
  }
  else{
    return false;
  }
}

Future<bool> handleLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token");
  if(token == null) return false;
  var r = await http.get(
    Uri.parse(baseUrl + "/auth/me"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  if(r.statusCode == 401){
    String newToken = await renewToken(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(r.body);
    if(newToken != "-"){
      prefs.setString("access_token", newToken);
    }else{
      print("Sloggato");
      prefs.setBool("logged_in", false);
      prefs.remove("access_token");
      return false;
    }
  }
  print(token);
  return true;
}

Future<String> renewToken(String oldToken) async{
  var r = await http.post(
  Uri.parse(baseUrl + "/auth/refresh"),
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

/* 

  HOME PAGE

*/

Future<dynamic> getUsersInfo() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token");
  var r = await http.get(
    Uri.parse(baseUrl + "/auth/me"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> getUsersLastStops() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/user/stays/lasts"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> getCards() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/user/appHomeCards"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}


/* 

  RIGHT NOW PAGE

*/

Future<dynamic> getParkingStatus() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/park/status"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> getFreePlace() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/park/getFree"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

/* 

  PAYMENT METHODS

*/

Future<dynamic> getPaymentMethods() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/user/paymentMethods/list"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> deletePaymentMethod(String cardID) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.delete(
    Uri.parse(baseUrl + "/user/paymentMethods/delete/" + cardID),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> setDefaultPaymentMethod(String cardID) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  Map data = {
    'card_id': cardID
  };
  var r = await http.post(
    Uri.parse(baseUrl + "/user/paymentMethods/setDefault"),
    headers: {
      'Authorization': 'Bearer ' + token
    },
    body: data
  );
  return jsonDecode(r.body);
}

Future<bool> addPaymentMethod(String cardNumber, String expiryDate, String cardHolderName, String cvv) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 

  Map data = {
    'card_number': cardNumber,
    'expiration_month': expiryDate.split('/')[0],
    'expiration_year': '20' + expiryDate.split('/')[1],
    'cvc': cvv
  };

  var r = await http.post(
    Uri.parse(baseUrl + "/user/paymentMethods/add"),
    headers: {
      'Authorization': 'Bearer ' + token
    },
    body: data
  );
  print(r.body);
  if(r.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

/* 

  VEHICLES PAGE

*/

Future<dynamic> getVehicles() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.get(
    Uri.parse(baseUrl + "/user/vehicles/list"),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}

Future<dynamic> deleteVehicle(String vehicleID) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("access_token"); 
  var r = await http.delete(
    Uri.parse(baseUrl + "/user/vehicles/delete/" + vehicleID),
    headers: {
      'Authorization': 'Bearer ' + token
    }
  );
  return jsonDecode(r.body);
}