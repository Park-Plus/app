import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/functions.dart';

class VehiclesScreen extends StatefulWidget {
  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;

  List vehicles;
  bool hasObtainedInfos = false;

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _show = true;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {}
    });
  }

  Future<void> _getVehicles() async {
    if (await handleLogin()) {
      dynamic resp = await getVehicles();
      if (this.mounted) {
        setState(() {
          vehicles = resp;
          hasObtainedInfos = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    handleScroll();
    _getVehicles();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Container(
                child: Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Veicoli registrati",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.black))),
                                Text(
                                    "Premi il pulsante a lato per aggiungere un nuovo veicolo, o scorri verso sinistra su di uno per modificarlo o eliminarlo."),
                              ]),
                        ),
                        Spacer(),
                        ClipOval(
                          child: Material(
                            color: Colors.green[800], // button color
                            child: InkWell(
                              splashColor: Colors.green[200], // inkwell color
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.add, color: Colors.white)),
                              onTap: () {},
                            ),
                          ),
                        )
                      ]),
                    ),
                    alignment: Alignment.centerLeft))),
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  child: hasObtainedInfos
                      ? FutureBuilder(
                          future: _getVehicles(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: vehicles.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: Key(index.toString()),
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.20,
                                  child: Container(
                                    color: Color(0xffF8F8F8),
                                    child: ListTile(
                                      leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: NetworkImage(utilsBaseUrl +
                                                  "/plates_generator/plate.php?plate=" +
                                                  vehicles[index]["plate"]),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                            )
                                          ]),
                                      title: Text(vehicles[index]["name"]),
                                      subtitle: Text("Ultimo posteggio il " +
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(vehicles[index]
                                                      ["last_stay"]
                                                  .toString()
                                                  .substring(0, 10)))),
                                    ),
                                  ),
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: 'Modifica',
                                      color: Colors.yellow[800],
                                      icon: Icons.edit,
                                      onTap: () {},
                                    ),
                                    IconSlideAction(
                                      closeOnTap: false,
                                      caption: 'Elimina',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        return showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Elimina'),
                                              content: Text(
                                                  'Sei sicuro di voler eliminare questo veicolo?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('ANNULLA',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .green[800])),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                ),
                                                TextButton(
                                                  child: Text('CONFERMA',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  onPressed: () async {
                                                    EasyLoading.show(
                                                        status:
                                                            "Eliminazione...");
                                                    await deleteVehicle(
                                                        vehicles[index]["id"]
                                                            .toString());
                                                    EasyLoading.showSuccess(
                                                        "Eliminato!");
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          })
                      : SpinKitRipple(color: Colors.green[800]))),
        ),
      ])),
    );
  }
}
