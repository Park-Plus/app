import 'package:flutter/material.dart';

Widget switchToPremium(context, js, index) {
  return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue[400], Colors.blue[700]]),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width * 0.15) / 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(js[index]["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.065,
                          color: Colors.white))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Tariffa scontata, nessuna commissione.\n",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    TextSpan(text: "Passa ora al piano Premium!"),
                  ]))),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.star),
                        label: Text("Fai l'upgrade"),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          onSurface: Colors.grey,
                          side: BorderSide(width: 2, color: Colors.white),
                        ))),
              )
            ],
          ),
        ),
      ));
}
