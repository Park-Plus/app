import 'package:flutter/material.dart';

Widget unpaidInvoice(context, js, index) {
  double unpaidTotal = 0.0;
  js[index]['data']["invoice"]
      .forEach((element) => unpaidTotal += element["price"]);
  return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.orange[400], Colors.orange[700]]),
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
                        text: "Hai " +
                            js[index]['data']['unpaid_count'].toString() +
                            " " +
                            js[index]["title"].toLowerCase() +
                            " per un totale di " +
                            unpaidTotal.toStringAsFixed(2) +
                            "€.",
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: " Salda ora per poter usare Park+.",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]))),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.double_arrow),
                        label: Text("Vai alle fatture"),
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
