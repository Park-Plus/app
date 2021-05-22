import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_emoji/flutter_emoji.dart';

T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
}

Widget ongoingStay(context, js, index){

  List<String> randomPhrases = ["La tua auto è sana e tranquilla! :sunglasses:", "Prendila con comodo. :innocent:", "Facile, no? :nerd_face:"];
  var parser = EmojiParser();

  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.green[400],
          Colors.green[700]
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
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/plate.png'), width: MediaQuery.of(context).size.width * 0.4,),
                  Spacer(),
                  Column(children: [ Text("1.50€", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white)), Text("00:15", style: TextStyle(color: Colors.white))]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(alignment: Alignment.centerLeft, child: Text(parser.emojify(getRandomElement(randomPhrases)), style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    )
  );
}