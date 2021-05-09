import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkplus/pages/home/screens/right_now_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/profile_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentPage = 0;

  /*
   0: Home
   1: Prenotazioni
   2: Veicoli
   3: Profilo
  */

  Size size;
  double statusBarHeight;

  @override
  void initState() {
    super.initState();
  }

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");
  ScrollController _scrollController = new ScrollController(); // set controller on scrolling
  bool _show = false;

  Widget content;

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    if(_currentPage == 0){
      content = new HomeScreen(statusBarHeight: statusBarHeight);
    }
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (_currentPage != 0) ? AppBar(
        backgroundColor: Colors.green[800],
      ) : null,
      backgroundColor: Color(0xffF8F8F8),
      body: content, 
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[800],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Stato attuale", icon: Icon(Icons.check)),
          BottomNavigationBarItem(label: "Prenotazioni", icon: Icon(Icons.lock)),
          BottomNavigationBarItem(label: "Profilo", icon: Icon(Icons.person)),
        ],
        onTap: (index){
          setState(() {
            switch(index){
              case 0:
                content = new HomeScreen(statusBarHeight: statusBarHeight);
                break;
              case 1:
                content = new RightNowScreen();
                break;
              case 2:
                content = new BookingsScreen();
                break;
              case 3:
                content = new ProfileScreen();
                break;                
            }
            _currentPage = index;
          });
        },
      ),
      floatingActionButton: Visibility(
        visible: _show,
        child: FloatingActionButton(
          backgroundColor: Colors.green[800],
          child: Icon(Icons.arrow_upward), onPressed: () {
            _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
            setState(() {
              _show = false;
            });
          }
        )
      )
    );
  }

}