import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/pages/profile/payments/payment_methods.dart';
import 'package:parkplus/pages/profile/vehicles.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/functions.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  @override
  void initState() {
    super.initState();
    _getUsersInfo();
  }

  @override
  void dispose(){
     super.dispose();
  }

  dynamic userInfo;
  bool hasObtainedUserInfos = false;

  _getUsersInfo() async{
    if(await handleLogin()){
      dynamic resp = await getUsersInfo();
      setState(() {
        userInfo = resp;
        hasObtainedUserInfos = true; 
      });
    }
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
                child: hasObtainedUserInfos ? Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(userInfo['profile_picture']), radius: 35,),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text(userInfo['name'] + " " + userInfo['surname'], style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                          Text("Registrato a Park+ dal " + DateFormat('dd/MM/yyyy').format(DateTime.parse(userInfo['created_at'].toString().substring(0, 10)))),
                          (userInfo["plan"] == "premium") ? Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Badge(
                              toAnimate: false,
                              shape: BadgeShape.square,
                              badgeColor: Colors.green[800],
                              badgeContent: Text('PREMIUM', style: TextStyle(color: Colors.white)),
                            ),
                          )
                          :
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Badge(
                              toAnimate: false,
                              shape: BadgeShape.square,
                              badgeColor: Colors.grey[700],
                              badgeContent: Text('FREE', style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                ) : SpinKitRipple(color: Colors.white),
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
                        onPressed: (BuildContext context) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethodsScreen()));
                        },
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