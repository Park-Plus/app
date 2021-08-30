import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/pages/home/home.dart';
import 'package:parkplus/pages/login_register/login_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInternetConnectionAvailable;
  bool viewNoInternet = false;

  Future<bool> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged_in') == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          ModalRoute.withName("/Home"));
      return Future.value(true);
    }
    return Future.value(false);
  }

  void _loginAndShowSplash() async {
    bool _loggedIn = false;
    if (isInternetConnectionAvailable != false) {
      _loggedIn = await autoLogin();
    }
    if (!_loggedIn || isInternetConnectionAvailable == false) {
      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        if (isInternetConnectionAvailable == false) {
          setState(() {
            viewNoInternet = true;
          });
        } else if (!_loggedIn) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return LoginRegister();
            }),
            (route) => false,
          );
        }
      });
    }
  }

  void _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("connesso");
        setState(() {
          isInternetConnectionAvailable = true;
        });
        _loginAndShowSplash();
      }
    } on SocketException catch (_) {
      print("Non connesso");
      setState(() {
        isInternetConnectionAvailable = false;
      });
    }
    _loginAndShowSplash();
  }

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[400], Colors.green[800]])),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Image(
                      image: AssetImage(viewNoInternet
                          ? 'assets/images/no_internet.png'
                          : 'assets/images/logo_new.png'),
                      width: 100,
                      height: 100)),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: viewNoInternet
                          ? Text(
                              "Park+ ha bisogno di una connessione ad internet per funzionare.\n\nProva a controllare il funzionamento della tua connessione e riprova!",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          : SpinKitThreeBounce(
                              color: Colors.white, size: 25.0)))
            ],
          ))),
    );
  }
}
