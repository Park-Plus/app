import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RightNowScreen extends StatefulWidget {
  @override
  _RightNowScreenState createState() => _RightNowScreenState();
}

class _RightNowScreenState extends State<RightNowScreen> {

  dynamic parkInfo;
  bool hasObtainedParkInfos = false;
  Timer timer;

  _getParkInfos() async{
    if(await handleLogin()){
      dynamic resp = await getParkingStatus();
      setState(() {
        parkInfo = resp;
        hasObtainedParkInfos = true; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getParkInfos();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _getParkInfos());
  }

  @override
  void dispose(){
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Align(child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(alignment: Alignment.centerLeft, child: Text("Stato attuale", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black))),
                            Text("Aggiornato ogni 5 secondi, permette di avere una visuale rapida su quanti posti liberi ci sono."),
                          ]
                        ),
                      ),
                  ]
                ),
              ), alignment: Alignment.centerLeft)
            )
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.17,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hasObtainedParkInfos ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: parkInfo["free"].toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035, fontWeight: FontWeight.bold, color: Colors.green[800])),
                            TextSpan(text: " posti liberi", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035, color: Colors.black))
                          ]
                        )
                      ) : SpinKitRipple(color: Colors.green[800]),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextButton.icon(
                          icon: Icon(Icons.bolt),
                          label: Text("INDICANE UNO"),
                          onPressed: () async {
                            dynamic data = await getFreePlace();
                            Alert(
                              context: context,
                              title: "Posto trovato! 🚀",
                              desc: "Il posto " + data["section"] + data["number"].toString() + " è libero!",
                              buttons: [
                              DialogButton(
                                child: Text(
                                  "Chiudi",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ]
                            ).show();
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green[800]
                          ),
                        ),
                      )
                    ],
                  )
                )
              )
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.025),
              child: hasObtainedParkInfos ? GridView.builder(
                itemCount: parkInfo["list"].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    color: parkInfo["list"][index]["status"] == "free" ? Colors.green : (parkInfo["list"][index]["status"] == "occupied" ? Colors.red : Colors.blue),
                    child: Center(
                      child: Text(
                        parkInfo["list"][index]["section"] + parkInfo["list"][index]["number"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.075, color: Colors.white)
                      ),
                    ),
                  );
                },
              ) : SpinKitRipple(color: Colors.green[800]),
            )
          )
        ]
      )
    );
  }
}