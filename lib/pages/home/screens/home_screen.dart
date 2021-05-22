import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/functions.dart';
import 'package:parkplus/pages/home/cards/next_milestones.dart';
import 'package:parkplus/pages/home/cards/ongoing_stay.dart';
import 'package:parkplus/pages/home/cards/switch_to_premium.dart';
import 'package:parkplus/pages/home/cards/unpaid_invoice.dart';
import 'package:parkplus/pages/login_register/login_register.dart';
class HomeScreen extends StatefulWidget {

  final double statusBarHeight;

  HomeScreen({this.statusBarHeight});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ScrollController _scrollController = new ScrollController();
  int _current = 0;
  int _itemsCount = 5;

  dynamic userInfo;
  dynamic lastStops;
  dynamic items; 
  bool hasObtainedUserInfos = false;
  bool hasObtainedLastStops = false;
  bool hasObtainedCards = false;

  _getUsersInfo() async{
    if(await handleLogin()){
      dynamic resp = await getUsersInfo();
      if(this.mounted){
        setState(() {
          userInfo = resp;
          hasObtainedUserInfos = true; 
        });
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginRegister()));
    }
  }

  Future<void> _getVehicles() async{
    if(await handleLogin()){
      dynamic resp = await getUsersLastStops();
      if(this.mounted){
        setState(() {
          lastStops = resp;
          hasObtainedLastStops = true; 
          _itemsCount = lastStops.length;
        });
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginRegister()));
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsersInfo();
    _getVehicles();
  }

  @override
  void dispose(){
     _scrollController.removeListener(() {});
     super.dispose();
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    await getCards().then((value){
      setState(() {
        items = value;
        hasObtainedCards = true;
      });
      buildCardsList();
    });
  }

  List<Widget> cards = [];

  void buildCardsList(){
    int itemsCount = (items.length > 3) ? 3 : items.length;
    for(int i = 0; i < itemsCount; i++){
      if(items[i]["type"] == "UNPAID_INVOICE"){
        cards.add(unpaidInvoice(context, items, i));
      }else if(items[i]["type"] == "ONGOING_STAY"){
        cards.add(ongoingStay(context, items, i));
      }else if(items[i]["type"] == "SWITCH_TO_PREMIUM"){
        cards.add(switchToPremium(context, items, i));
      }else if(items[i]["type"] == "NEXT_MILESTONES"){
        cards.add(nextMilestones(context, items, i));
      }else{
        cards.add(Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(child: Text('', style: TextStyle(fontSize: 16.0),))
        ));     
      }
    }
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
                    autoPlayInterval: const Duration(seconds: 10),
                    autoPlay: true,
                    enableInfiniteScroll: hasObtainedCards ? ((items.length == 1) ? false : true ): false,
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height * 0.2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                  ),
                  items: [0, 1, 2].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return cardWidget(context, i);
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
                    onPressed: () async {
                    },
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
                child: hasObtainedLastStops ? ((_itemsCount == 0 ) ? 
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
                          title: Text(lastStops[index]['vehicle']['name'] + " il " + DateFormat('dd/MM/yyyy').format(DateTime.parse(lastStops[index]['date'].toString().substring(0, 10)))),
                          subtitle: Text("Pagati €" + lastStops[index]['invoice']['price'].toStringAsFixed(2)),
                          trailing: Icon(Icons.arrow_right),
                        );
                      },
                    );
                  }
                )) : SpinKitRipple(color: Colors.green[800])
              ),
            ),
          ]
        )
      );
  }
}