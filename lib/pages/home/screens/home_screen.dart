import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {

  final double statusBarHeight;

  HomeScreen({this.statusBarHeight});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double statusBarHeight;

  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;
  int _current = 0;

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
          setState(() {
            _show = true;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
      }
    });
  }

  _setStatusBarHeight() {
    setState(() {
      statusBarHeight = widget.statusBarHeight;
    });
  }

  Future<void> _getVehicles(){
    return Future.value();
  }


  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  int _itemsCount = 0;

  @override
  void initState() {
    super.initState();
    _setStatusBarHeight();
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
              height: 60,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Benvenuto, ", style: TextStyle(fontSize: 20, color: Colors.white),),
                          TextSpan(text: "Utente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                        ]
                      )
                    ),
                    Spacer(),
                    CircleAvatar(backgroundImage: AssetImage('assets/images/me.jpg'), radius: 23, backgroundColor: Colors.white)
                  ],
                ),
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
                    margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 2.0),
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
              child: Align(alignment: Alignment.centerLeft, child: Text("Ultimi posteggi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
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
                      itemCount: 1,
                      itemBuilder: (context, index){
                        return ListTile(
                          leading: CircleAvatar(child: Text((index + 1).toString()), backgroundColor: Colors.green[800],),
                          title: Text("Volvo demmerda il 04/01/2021"),
                          subtitle: Text("Pagati €15.20"),
                          trailing: Icon(Icons.arrow_right),
                        );
                      },
                    );
                  }
                )
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextButton(child: Text("Vedi tutti..."), onPressed: (){}),
            ),
          ]
        )
      );
  }
}