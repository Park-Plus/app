import 'package:parkplus/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:parkplus/pages/login_register/login_register.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {  

  Future<bool> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('logged_in') == true){
      Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(
            builder: (context) => Home()
          ), 
        ModalRoute.withName("/Home")
      );
      return Future.value(true);
    }
    return Future.value(false);
  }

  void _loginAndShowSplash() async {
    bool _loggedIn = await autoLogin();
    if(!_loggedIn){
      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context){
              return LoginRegister();
            }
          ),
          (route) => false,
        );
      });
    }
  }

  @override
  void initState() {
    _loginAndShowSplash();
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
            colors: [Colors.green[400], Colors.green[800]]
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 100,
                  height: 100
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 25.0
                )
              )
            ],
          )
        )
      ),
    );
  }
}