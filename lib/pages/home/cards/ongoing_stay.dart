import 'package:flutter/material.dart';
import 'dart:math';
import 'package:parkplus/functions.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

T getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}

Widget ongoingStay(context, js, index) {
  var currentStayTime = DateTime.now()
      .difference(DateTime.parse(js[index]["data"]["stay"]["created_at"]));
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(currentStayTime.inMinutes.remainder(60));

  List<String> randomPhrases = [
    "La tua auto è sana e tranquilla! :sunglasses:",
    "Prendila con comodo. :innocent:",
    "Facile, no? :nerd_face:"
  ];
  var parser = EmojiParser();

  return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green[400], Colors.green[700]]),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Image(
                      image: NetworkImage(utilsBaseUrl +
                          "/plates_generator/plate.php?plate=" +
                          js[index]["data"]["vehicle"]["plate"]),
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Spacer(),
                    Column(children: [
                      Text(
                          js[index]["data"]["stay"]["current_price"]
                                  .toStringAsPrecision(2) +
                              "€",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.white)),
                      Text(
                          twoDigits(currentStayTime.inHours) +
                              ":" +
                              twoDigitMinutes,
                          style: TextStyle(color: Colors.white))
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(parser.emojify(getRandomElement(randomPhrases)),
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ));
}
