import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'package:parkplus/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  final double statusBarHeight;

  HomeScreen({this.statusBarHeight});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ScrollController _scrollController = new ScrollController();
  bool _show = false;
  int _current = 0;

  dynamic userInfo;
  bool hasObtainedUserInfos = false;

  _getUsersInfo() async{
    SharedPreferences userData = await SharedPreferences.getInstance();
    print(userData.getString("access_token"));
    if(await handleLogin()){
      dynamic resp = await getUsersInfo();
      setState(() {
        userInfo = resp;
        hasObtainedUserInfos = true; 
      });
    }
  }

  Future<void> _getVehicles(){
    return Future.value();
  }

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  int _itemsCount = 5;

  @override
  void initState() {
    super.initState();
    _getUsersInfo();
  }

  @override
  void dispose(){
     _scrollController.removeListener(() {});
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Container(
              height: widget.statusBarHeight,
              color: Colors.green[800]
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.11),
              decoration: BoxDecoration(
                  color: Colors.green[800],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(10, 3),
                    ),
                  ],
                ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: hasObtainedUserInfos ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Benvenuto, ", style: TextStyle(fontSize: 20, color: Colors.white),),
                          TextSpan(text: userInfo["name"] + " " + userInfo["surname"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                        ] 
                      )
                    ),
                    Spacer(),
                    CircleAvatar(backgroundImage: NetworkImage(userInfo["profile_picture"]), radius: 23, backgroundColor: Colors.white)
                  ],
                ) : SpinKitRipple(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.28,
              child: Column(
                children: [
                 CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height * 0.2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                  ),
                  items: [1, 2, 3].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(child: Text('', style: TextStyle(fontSize: 16.0),))
                          );
                        },
                      );
                    }).toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 2, 3].map((url) {
                  int index = [1, 2, 3].indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                        ? Colors.grey[700]
                        : Colors.grey[350],
                    ),
                  );
                }).toList(),
              ),
              ]
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Divider(thickness: 2),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Row(
                children: [
                  Text("Ultimi posteggi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Spacer(),
                  (_itemsCount != 0 ) ? TextButton.icon(
                    onPressed: (){},
                    label: Icon(Icons.double_arrow),
                    icon: Text("Vedi tutti"),
                    style: TextButton.styleFrom(
                      primary: Colors.green[800],
                      onSurface: Colors.grey,
                    )
                  ) : Text(""),
                ]
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.98,
                child: (_itemsCount == 0 ) ? 
                  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ 
                    Image(image: AssetImage('assets/images/rolling_eyes_face.png'), width: MediaQuery.of(context).size.width * 0.2 ), Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text("Non hai ancora nessuna sosta registrata.\nEffettua la tua prima con Park+!", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                    )
                    ]
                    ))
                 : FutureBuilder(
                  future: _getVehicles(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: _itemsCount,
                      itemBuilder: (context, index){
                        return ListTile(
                          tileColor: (index % 2 != 0) ? Colors.grey[200] : Theme.of(context).backgroundColor,
                          leading: CircleAvatar(child: Text((index + 1).toString()), backgroundColor: Colors.green[800],),
                          title: Text("Tesla Model S il 04/01/2021"),
                          subtitle: Text("Pagati €15.20"),
                          trailing: Icon(Icons.arrow_right),
                        );
                      },
                    );
                  }
                )
              ),
            ),
          ]
        )
      );
  }
}