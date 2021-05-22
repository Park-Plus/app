import 'package:flutter/material.dart';

Widget nextMilestones(context, js, index){
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.purple[400],
          Colors.purple[700]
        ]
      ),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width*0.15)/2),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.centerLeft, child: Text(js[index]["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.065, color: Colors.white))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Gestione di più parcheggi, PayPal e molto altro...", style: TextStyle(color: Colors.white)),
                    ]
                  )
                )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width, child: OutlinedButton.icon(
              onPressed: (){ // TODO: Aggiungere il link

              }, icon: Icon(Icons.favorite), label: Text("Scoprilo ora!"),
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  onSurface: Colors.grey,
                  side: BorderSide(width: 2, color: Colors.white),
                )
              )
            ),
          ],
        ),
      ),
    )
  );
}