import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/functions.dart';
import 'package:parkplus/pages/home/screens/bookings/new.dart';
import 'package:parkplus/pages/login_register/login_register.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  Future _getBookingsFuture;
  List bookings;
  bool isLoading = true;

  Future<void> _getBookings() async {
    if (await handleLogin()) {
      final now = new DateTime.now();
      dynamic resp = await getBookings();
      if (this.mounted) {
        setState(() {
          bookings = resp;
          isLoading = false;
        });
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginRegister()));
    }
  }

  @override
  void initState() {
    super.initState();
    _getBookingsFuture = _getBookings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var parser = EmojiParser();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width,
          child: Container(
              child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Prenotazioni",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.black))),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      "Da qui puoi visualizzare tutte le tue prenotazioni passate, attive e crearne di nuove.",
                                      style: TextStyle(color: Colors.black))),
                            ]),
                      ),
                    ]),
                  ),
                  alignment: Alignment.centerLeft))),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextButton.icon(
          icon: Icon(Icons.add),
          label: Text("NUOVA"),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewBookingScreen()));
          },
          style: TextButton.styleFrom(
              primary: Colors.white, backgroundColor: Colors.green[800]),
        ),
      ),
      Expanded(
        child: !isLoading
            ? FutureBuilder(
                future: _getBookingsFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: (index % 2 != 0)
                            ? Colors.grey[200]
                            : Theme.of(context).backgroundColor,
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                          backgroundColor: Colors.green[800],
                        ),
                        title: Text(dateFormat
                                .parse(bookings[index]["start"])
                                .hour
                                .toString()
                                .padLeft(2, '0') +
                            ":" +
                            dateFormat
                                .parse(bookings[index]["start"])
                                .minute
                                .toString()
                                .padLeft(2, '0') +
                            " - " +
                            dateFormat
                                .parse(bookings[index]["end"])
                                .hour
                                .toString()
                                .padLeft(2, '0') +
                            ":" +
                            dateFormat
                                .parse(bookings[index]["end"])
                                .minute
                                .toString()
                                .padLeft(2, '0') +
                            " del " +
                            dateFormat
                                .parse(bookings[index]["end"])
                                .day
                                .toString()
                                .padLeft(2, '0') +
                            "/" +
                            dateFormat
                                .parse(bookings[index]["end"])
                                .month
                                .toString()
                                .padLeft(2, '0') +
                            "/" +
                            dateFormat
                                .parse(bookings[index]["end"])
                                .year
                                .toString()
                                .padLeft(4, '0')),
                        subtitle: Text(parser
                            .emojify(bookings[index]["status"] == "pending"
                                ? ":thumbsup: Confermata"
                                : bookings[index]["status"] == "active"
                                    ? ":hourglass_flowing_sand: In corso"
                                    : bookings[index]["status"] == "ended"
                                        ? ":clock1: Terminata"
                                        : ":wastebasket: Cancellata")),
                      );
                    },
                  );
                })
            : SpinKitRipple(color: Colors.green[800]),
      )
    ]));
  }
}
