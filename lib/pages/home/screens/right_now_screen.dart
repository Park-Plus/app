import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RightNowScreen extends StatefulWidget {
  @override
  _RightNowScreenState createState() => _RightNowScreenState();
}

class _RightNowScreenState extends State<RightNowScreen> {

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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "5", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035, fontWeight: FontWeight.bold, color: Colors.green[800])),
                            TextSpan(text: " posti liberi", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035, color: Colors.black))
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextButton.icon(
                          icon: Icon(Icons.bolt),
                          label: Text("INDICANE UNO"),
                          onPressed: (){},
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
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(100, (index) {
                  return Container(
                    color: (index % 5 != 0) ? Colors.red : Colors.green,
                    child: Center(
                      child: Text(
                        'C$index',
                      ),
                    ),
                  );
                }),
              ),
            )
          )
        ]
      )
    );
  }
}