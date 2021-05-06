import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  static List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    super.initState();
    _pages.add(HomeScreen(statusBarHeight: statusBarHeight));
    _pages.add(bookingsScreen());
    _pages.add(VehiclesScreen());
    _pages.add(profileScreen());
  }

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");
  ScrollController _scrollController = new ScrollController(); // set controller on scrolling
  bool _show = false;

  Widget content = HomeScreen();

  @override
  Widget build(BuildContext context) {
    double _currSBHeight = MediaQuery.of(context).padding.top;
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
          BottomNavigationBarItem(label: "Prenotazioni", icon: Icon(Icons.check)),
          BottomNavigationBarItem(label: "Veicoli", icon: Icon(CupertinoIcons.car)),
          BottomNavigationBarItem(label: "Profilo", icon: Icon(Icons.person)),
        ],
        onTap: (index){
          setState(() {
            content = _pages[index];
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