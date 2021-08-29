import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:parkplus/functions.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  @override
  _AddPaymentMethodScreenState createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  ScrollController _scrollController = new ScrollController(); // se
  bool _show = false;

  List paymentMethods;
  bool hasObtainedInfos = false;

  final SlidableController slidableController = SlidableController();

  List<String> items = List<String>.generate(10000, (i) => "Nome auto $i");

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aggiungi carta"),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cardBgColor: Colors.green[800],
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: false,
            obscureCardCvv: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: false,
                    obscureNumber: false,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: Colors.green,
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Intestatario',
                    ),
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Numero della carta',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Data di scadenza',
                      hintText: 'MM/AA',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV (a 3 cifre, sul retro)',
                      hintText: 'XXX',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: TextButton.icon(
                        icon: Icon(Icons.check),
                        label: Text("SALVA"),
                        onPressed: () async {
                          EasyLoading.show(status: 'Salvataggio...');
                          bool success = await addPaymentMethod(
                              cardNumber, expiryDate, cardHolderName, cvvCode);
                          if (success)
                            EasyLoading.showSuccess('Salvato!');
                          else
                            EasyLoading.showError('Errore.');
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green[800],
                          onSurface: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "I pagamenti sono processati tramite Stripe, non salviamo i tuoi dati di pagamento sui nostri database.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ))
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
