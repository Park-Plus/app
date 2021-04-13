import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class login extends StatefulWidget {

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[400], Colors.green[800]]
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(10, 3),
            ),
          ],
        ),
        height: 200.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 50,
              height: 50
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text("Accedi", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30, color: Colors.white))
              ),
            )
          ]
        ),
      ),
    );
  }
}