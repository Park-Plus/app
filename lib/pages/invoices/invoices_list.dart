import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/functions.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/pages/login_register/login_register.dart';

class InvoicesScreen extends StatefulWidget {
  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {

  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;

  List invoices;
  dynamic unpaidTotal = 0;
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
          ScrollDirection.forward) {
      }
    });
  }

  Future<void> _getInvoices() async{
    if(await handleLogin()){
      dynamic resp = await getInvoices();
      if(this.mounted){
        setState(() {
          invoices = resp["invoices"];
          unpaidTotal = resp["unpaid_total"];
          hasObtainedInfos = true; 
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    handleScroll();
    _getInvoices();
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
                    child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(alignment: Alignment.centerLeft, child: Text("Fatture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black))),
                                Align(alignment: Alignment.centerLeft, child: Text("Visualizza qui lo stato delle tue fatture. Fai tap su una di esse per maggiori informazioni.")),
                              ]
                            ),
                          ),
                      ]
                    ),
                  ), alignment: Alignment.centerLeft)
                )
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: hasObtainedInfos ? FutureBuilder(
                      future: _getInvoices(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: invoices.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              tileColor: index % 2 == 0 ? Colors.grey[200] : Theme.of(context).backgroundColor,
                              title: Text(invoices[index]["price"].toStringAsFixed(2) + "€"),
                              subtitle: Text((invoices[index]["relation"]["type"] == "stop" ? "Sosta" : "Passaggio a premium") + " del " + invoices[index]["relation"]["date"] + " - #" + invoices[index]["id"].toString()),
                              leading: ClipOval(
                                child: Material(
                                  color: invoices[index]["status"] == "paid" ? Colors.green[800] : Colors.red, // button color
                                  child: SizedBox(width: 40, height: 40, child: Icon(CupertinoIcons.car, color: Colors.white)),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: 
                                [
                                  Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: invoices[index]["status"] == "paid" ? Colors.green[800] : Colors.red,
                                    badgeContent: Text(invoices[index]["status"] == "paid" ? 'PAGATA' : 'NON PAGATA', style: TextStyle(color: Colors.white)),
                                  ),
                                  Icon(Icons.arrow_right)
                                ]
                              ),
                              onTap: (){

                              },
                            );
                          },
                        );
                      }
                    ) : SpinKitRipple(color: Colors.green[800])
                  )
                ),
              ),
            ]
          )
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: unpaidTotal != 0 ? FloatingActionButton.extended(
        onPressed: (){
          return showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Pagamento fatture non saldate'),
                content: Text('Verrà effettuato un tentativo di addebito sul tuo metodo di pagamento predefinito di ' + unpaidTotal.toStringAsFixed(2) + "€.\n\nSei sicuro?"),
                actions: <Widget>[
                  TextButton(
                    child: Text('ANNULLA', style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text('CONFERMA', style: TextStyle(color: Colors.green[800])),
                    onPressed: () async {
                      EasyLoading.show(status: "Tentativo di addebito...");
                      dynamic paymentStatus = await payUnpaidInvoices();
                      if(paymentStatus == 0){
                        EasyLoading.showError("Fatture non saldate!");
                      }else if(paymentStatus == -1){
                        EasyLoading.showError("Non tutte le fatture saldate!");
                      }else{
                        EasyLoading.showSuccess("Fatture saldate!");
                      }
                      Navigator.of(context).pop(true);                                    
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.credit_card),
        label: Text('PAGA LE FATTURE NON SALDATE'),
      ) : null,
    );
  }
}