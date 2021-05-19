import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parkplus/functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:parkplus/pages/profile/payments/add_payment_method.dart';

class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {

  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;

  List paymentMethods;
  bool hasObtainedInfos = false;

  final SlidableController slidableController = SlidableController();

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

  Future<void> _getPaymentMethods() async{
    if(await handleLogin()){
      dynamic resp = await getPaymentMethods();
      if(this.mounted){
        setState(() {
          paymentMethods = resp;
          hasObtainedInfos = true; 
        });
      }
    }
  }

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  @override
  void initState() {
    super.initState();
    handleScroll();
    _getPaymentMethods();
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(alignment: Alignment.centerLeft, child: Text("Metodi di pagamento", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.07, color: Colors.black))),
                                Text("Premi il pulsante a lato per aggiungere una nuova carta, o scorri verso sinistra su di una per impostarla come default o eliminarla."),
                              ]
                            ),
                          ),
                        Spacer(),
                        ClipOval(
                          child: Material(
                            color: Colors.green[800], // button color
                            child: InkWell(
                              splashColor: Colors.green[200], // inkwell color
                              child: SizedBox(width: 40, height: 40, child: Icon(Icons.add, color: Colors.white)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddPaymentMethodScreen()));
                              },
                            ),
                          ),
                        )
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
                      future: _getPaymentMethods(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index){
                            return Slidable(
                              controller: slidableController,
                              key: Key(index.toString()),
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.20,
                              child: Container(
                                color: Color(0xffF8F8F8),
                                child: ListTile(
                                  leading: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Image(image: AssetImage(paymentMethods[index]["brand"] == "Visa" ? 'assets/images/visa.png' : 'assets/images/mastercard.png'), width: MediaQuery.of(context).size.width * 0.10,) ]),
                                  title: Text(paymentMethods[index]["brand"] + " •••• " + paymentMethods[index]["last4"]),
                                  subtitle: Text("Scade il " + paymentMethods[index]["exp_month"].toString() + "/" + paymentMethods[index]["exp_year"].toString()),
                                  trailing: paymentMethods[index]["default"] ? Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.green[800],
                                    badgeContent: Text('DEFAULT', style: TextStyle(color: Colors.white)),
                                  ) : null,
                                ),
                              ),
                              secondaryActions: [
                                if(!paymentMethods[index]["default"]) IconSlideAction(
                                  caption: 'Default',
                                  color: Colors.yellow[800],
                                  icon: Icons.star,
                                  onTap: (){
                                    return showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Rendi default'),
                                        content: Text('Vuoi rendere metodo di pagamento di default la carta ' + paymentMethods[index]["brand"] + " •••• " + paymentMethods[index]["last4"] + '?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ANNULLA', style: TextStyle(color: Colors.grey[800])),
                                            onPressed: (){
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('CONFERMA', style: TextStyle(color: Colors.green[800])),
                                            onPressed: () async{
                                              Navigator.of(context).pop(true);
                                              EasyLoading.show(status: 'Salvataggio...');
                                              await setDefaultPaymentMethod(paymentMethods[index]["id"]);
                                              EasyLoading.showSuccess('Salvato!');
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  },
                                ),
                                if(paymentMethods.length > 1) IconSlideAction(
                                  closeOnTap: true,
                                  caption: 'Elimina',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: (){
                                    return showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Elimina'),
                                        content: Text('Sei sicuro di voler eliminare questo veicolo?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('ANNULLA', style: TextStyle(color: Colors.green[800])),
                                            onPressed: () => Navigator.of(context).pop(false),
                                          ),
                                          TextButton(
                                            child: Text('CONFERMA', style: TextStyle(color: Colors.red)),
                                            onPressed: () async{
                                              Navigator.of(context).pop(false);
                                              EasyLoading.show(status: 'Eliminazione...');
                                              await deletePaymentMethod(paymentMethods[index]["id"]);
                                              EasyLoading.showSuccess('Eliminato!');
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