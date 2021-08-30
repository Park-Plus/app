import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/functions.dart';
import 'package:parkplus/pages/login_register/login_register.dart';

class NewBookingScreen extends StatefulWidget {
  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  @override
  void initState() {
    super.initState();
    _getPlacesFuture = _getPlaces();
  }

  Future<void> _getPlaces() async {
    if (await handleLogin()) {
      final now = new DateTime.now();
      if (startTime != null && endTime != null) {
        DateTime start = DateTime(
            now.year, now.month, now.day, startTime.hour, startTime.minute);
        DateTime end = DateTime(
            now.year, now.month, now.day, endTime.hour, endTime.minute);
        if (start.millisecondsSinceEpoch < end.millisecondsSinceEpoch) {
          dynamic resp = await getAvailableBookingSlots(start, end);
          if (this.mounted) {
            setState(() {
              places = resp;
              isLoading = false;
              showList = true;
            });
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.red,
              content: new Text(
                  "L'ora di arrivo deve essere prima di quella di uscita!")));
        }
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginRegister()));
    }
  }

  void quitFromPage() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TimeOfDay startTime;
  TimeOfDay endTime;

  bool isLoading = false;
  bool showList = false;

  Future _getPlacesFuture;

  List places;

  var parser = EmojiParser();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: Container(
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
                                      child: Text("Nuova prenotazione",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.black))),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Inserisci la fascia oraria della prenotazione per visualizzare le opzioni disponibili.",
                                          style:
                                              TextStyle(color: Colors.black))),
                                ]),
                          ),
                        ]),
                      ),
                      alignment: Alignment.centerLeft))),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.height * 0.22,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text("Orario di entrata:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      TimeOfDay pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      setState(() {
                                        startTime = pickedTime;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                startTime != null
                                                    ? startTime.format(context)
                                                    : "Scegli...",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green[800],
                                        )),
                                  ),
                                ]),
                            Spacer(),
                            Icon(Icons.double_arrow, color: Colors.green[800]),
                            Spacer(),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text("Orario di uscita:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      TimeOfDay pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      setState(() {
                                        endTime = pickedTime;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green[800],
                                        ),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                endTime != null
                                                    ? endTime.format(context)
                                                    : "Scegli...",
                                                style: TextStyle(
                                                    color: Colors.white)))),
                                  ),
                                ]),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              child: Text("CERCA"),
                              onPressed: () {
                                _getPlaces();
                              },
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.green[800]),
                            ),
                          ),
                        )
                      ]),
                )),
          ),
          if (showList)
            Expanded(
              child: !isLoading
                  ? FutureBuilder(
                      future: _getPlacesFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                tileColor: (index % 2 != 0)
                                    ? Colors.grey[200]
                                    : Theme.of(context).backgroundColor,
                                leading: CircleAvatar(
                                  child: Text((index + 1).toString()),
                                  backgroundColor: Colors.green[800],
                                ),
                                title: Text(places[index]['section'] +
                                    places[index]['number'].toString() +
                                    " - Prenotabile"),
                                subtitle: Text(parser.emojify((places[index]
                                            ["previousBookings"] !=
                                        null
                                    ? ":rotating_light: " +
                                        places[index]["previousBookings"]
                                                ["count"]
                                            .toString() +
                                        " prenotazioni prima della tua"
                                    : ":thumbsup: Sei il primo della giornata!"))),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () async {
                                  return showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Conferma prenotazione'),
                                        content: Text(
                                            'Sei sicuro di voler prenotare il posteggio ' +
                                                places[index]['section'] +
                                                places[index]['number']
                                                    .toString() +
                                                ' per oggi dalle ' +
                                                startTime.format(context) +
                                                ' alle ' +
                                                endTime.format(context) +
                                                "?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ANNULLA',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                          TextButton(
                                            child: Text('CONFERMA',
                                                style: TextStyle(
                                                    color: Colors.green[800])),
                                            onPressed: () async {
                                              Navigator.of(context).pop(true);
                                              DateTime now = DateTime.now();
                                              EasyLoading.show(
                                                  status:
                                                      "Prenotazione in corso...");
                                              await bookPlace(
                                                  DateTime(
                                                      now.year,
                                                      now.month,
                                                      now.day,
                                                      startTime.hour,
                                                      startTime.minute),
                                                  DateTime(
                                                      now.year,
                                                      now.month,
                                                      now.day,
                                                      endTime.hour,
                                                      endTime.minute),
                                                  places[index]['section'] +
                                                      places[index]['number']
                                                          .toString());
                                              EasyLoading.showSuccess(
                                                  "Prenotato!");
                                              quitFromPage();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                          },
                        );
                      })
                  : SpinKitRipple(color: Colors.green[800]),
            )
        ])));
  }
}
