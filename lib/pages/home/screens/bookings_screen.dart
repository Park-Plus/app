import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {

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
                            Align(alignment: Alignment.centerLeft, child: Text("Prenotazioni", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black))),
                          ]
                        ),
                      ),
                  ]
                ),
              ), alignment: Alignment.centerLeft)
            )
          ),
        ]
      )
    );
  }

}