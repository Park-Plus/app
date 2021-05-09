import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkplus/pages/home/screens/vehicles_screen.dart';
import 'package:settings_ui/settings_ui.dart';

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
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
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
                              toAnimate: false,
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
              padding: EdgeInsets.only(top: 8.0),
              child: SettingsList(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                sections: [
                  SettingsSection(
                    title: 'Premium',
                    tiles: [
                      SettingsTile(
                        title: 'Passa a premium',
                        leading: Icon(Icons.star),
                        onPressed: (BuildContext context) {},
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Le mie informazioni',
                    tiles: [
                      SettingsTile(
                        title: 'I miei veicoli',
                        leading: Icon(CupertinoIcons.car),
                        onPressed: (BuildContext context) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VehiclesScreen()));
                        },
                      ),
                      SettingsTile(
                        title: 'Metodi di pagamento',
                        leading: Icon(Icons.credit_card),
                        onPressed: (BuildContext context) {},
                      ),
                      SettingsTile(
                        title: 'Fatture',
                        leading: Icon(Icons.money),
                        onPressed: (BuildContext context) {},
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Sicurezza',
                    tiles: [
                      SettingsTile(
                        title: 'Logout',
                        leading: Icon(Icons.logout),
                        onPressed: (BuildContext context) {},
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}