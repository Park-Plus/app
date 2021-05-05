import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Color(0xffF8F8F8),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: Container()
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[800],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Prenotazioni", icon: Icon(Icons.check)),
          BottomNavigationBarItem(label: "Veicoli", icon: Icon(CupertinoIcons.car)),
          BottomNavigationBarItem(label: "Profilo", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}