import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class StaysScreen extends StatefulWidget {
  @override
  _StaysScreenState createState() => _StaysScreenState();
}

class _StaysScreenState extends State<StaysScreen> {

  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;

  List stays;
  bool hasObtainedInfos = false;

  Future getStaysFuture;

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
          setState(() {
            _show = true;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
      }
    });
  }

  Future<void> _getStays() async{
    if(await handleLogin()){
      dynamic resp = await getUsersLastStops();
      if(this.mounted){
        setState(() {
          stays = resp;
          hasObtainedInfos = true; 
        });
      }
    }
  }

  Future _handleRefresh() {
    setState(() {
      hasObtainedInfos = false;
      stays = null;
    });
    _getStays();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Aggiornato!"),
      duration: Duration(seconds: 2),
    ));
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    handleScroll();
    getStaysFuture = _getStays();
  }

  @override
  void dispose(){
     _scrollController.removeListener(() {});
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Align(child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text("Le tue soste", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black))),
                          Text("Qui sotto è riportata la cronologia completa delle tue soste. Trascina verso il basso per aggiornare."),
                        ]
                      ),
                    ),
                  ),
                ), alignment: Alignment.centerLeft)
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: hasObtainedInfos ? FutureBuilder(
                      future: getStaysFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return RefreshIndicator(
                          backgroundColor: Theme.of(context).accentColor,
                          color: Colors.white,
                          onRefresh: _handleRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: stays.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                tileColor: (index % 2 != 0) ? Colors.grey[200] : Theme.of(context).backgroundColor,
                                leading: CircleAvatar(child: Text((index + 1).toString()), backgroundColor: Colors.green[800],),
                                title: Text(stays[index]['vehicle']['name'] + " il " + DateFormat('dd/MM/yyyy').format(DateTime.parse(stays[index]['date'].toString().substring(0, 10)))),
                                subtitle: Text("Pagati €" + stays[index]['invoice']['price'].toStringAsFixed(2)),
                                trailing: Icon(Icons.arrow_right),
                              );
                            },
                          ),
                        );
                      }
                    ) : SpinKitRipple(color: Colors.green[800])
                  )
                ),
              ),
            ]
          )
        ),
    );
  }
}