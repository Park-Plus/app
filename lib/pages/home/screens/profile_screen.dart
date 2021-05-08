import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parkplus/pages/home/home.dart';
import 'package:parkplus/pages/home/screens/vehicles_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage('assets/images/me.jpg'), radius: 35,),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text("Mattia Effendi", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                          Text("Registrato a Park+ dal 08/05/2021"),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Badge(
                              shape: BadgeShape.square,
                              badgeColor: Colors.green[800],
                              badgeContent: Text('PREMIUM', style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                ),
              )
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.star, color: Colors.grey[700]), backgroundColor: Colors.green[200],),
                    title: Text('Passa a premium'),
                    subtitle: Text('Nessun costo di prenotazione, priorità e molto altro!'),
                  ),
                  ListTile(
                    title: Text('')
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(CupertinoIcons.car, color: Colors.grey[700]), backgroundColor: Colors.grey[300],),
                    title: Text('I miei veicoli'),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VehiclesScreen()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.money, color: Colors.grey[700]), backgroundColor: Colors.grey[300],),
                    title: Text('Fatture')
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.credit_card, color: Colors.grey[700]), backgroundColor: Colors.grey[300],),
                    title: Text('Metodi di pagamento')
                  ),
                  ListTile(
                    title: Text('')
                  ),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.logout, color: Colors.red), backgroundColor: Colors.red[200],),
                    title: Text('Logout')
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}