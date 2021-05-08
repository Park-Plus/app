import 'package:parkplus/pages/home/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

TValue case2<TOptionType, TValue>(
  TOptionType selectedOption,
  Map<TOptionType, TValue> branches, [
  TValue defaultValue,
]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }

  return branches[selectedOption];
}

class LoginRegister extends StatefulWidget {
  LoginRegister({Key key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {

  int pagina = 0;
  int prevState = 0;

  bool mailErrata = false;
  bool isPasswordVisible = false;

  Future<bool> _interceptBackKey() {
    setState(() {
          pagina = prevState;
    });
  }

  final formKey = GlobalKey<FormBuilderState>();
  final formKey2 = GlobalKey<FormBuilderState>();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _interceptBackKey,
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green[400], Colors.green[800]]
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(10, 3),
                    ),
                  ],
                ),
                height: 300.0,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 50,
                        height: 50
                      ),
                      padding: EdgeInsets.only(
                        bottom: 20
                      ),
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Benvenuto in "),
                            TextSpan(text: "Park+", style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '\n'),
                            TextSpan(text: 'Un nuovo modo per parcheggiare.', style: TextStyle(fontSize: 17)),
                          ], 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          )
                        )
                      )
                    ),
                  ]
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: case2(pagina,
                {
                  0: loginRegisterButtons(context),
                  1: loginFields(context),
                  2: registerFields(context),
                }, loginRegisterButtons(context)),
                transitionBuilder: (widget, animation) => FadeTransition(
                  opacity: animation,
                  child: widget,
                )
              ),
            ],
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            height: pagina == 0 ? MediaQuery.of(context).size.height * 0.20 : MediaQuery.of(context).size.height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (pagina == 1 || pagina == 2 ) ? InkWell(
                  enableFeedback: false,
                  onTap: (){
                    setState(() {
                      prevState = 0;
                      if(pagina == 2) pagina = 1; else if(pagina == 1) pagina = 2;
                    });
                  },
                  child: 
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            if(pagina == 1) TextSpan(text: "Non hai ancora un account? ") else if(pagina == 2) TextSpan(text: "Hai già un account? ") ,
                            if(pagina == 1) TextSpan(text: "Registrati ora", style: TextStyle(fontWeight: FontWeight.bold)) else if(pagina == 2) TextSpan(text: "Accedi", style: TextStyle(fontWeight: FontWeight.bold))
                          ], 
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          )
                        )
                      )
                ) : Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Row(
                    children: [
                      Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check, color: Colors.green[800]), Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Prenota un posto", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[850])),
                      )],)),
                      Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.attach_money, color: Colors.green[800]), Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Paga facilmente", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[850])),
                      )],)),
                      Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bolt, color: Colors.green[800]), Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Tutto a colpo d'occhio", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[850])),
                      )],)),
                      Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.delete, color: Colors.green[800]), Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Mai più biglietti", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[850])),
                      )],)),
                    ]
                  ),
                )
              ],
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Container loginRegisterButtons(BuildContext context) {
    return Container(
      key: Key('login_register_buttons'),
      child: Padding(
        padding: EdgeInsets.only(
          top: 50.0,
          bottom: 50.0
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  enableFeedback: false,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  color: Colors.green[700],
                  onPressed: (){
                    setState((){
                      prevState = 0;
                      pagina = 1;
                    });
                  },
                  child: Text("ACCEDI", style: TextStyle(color: Colors.white))
                )
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  enableFeedback: false,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  color: Colors.grey[300],
                  onPressed: (){
                    setState(() {
                      prevState = 0;
                      pagina = 2;                       
                    });
                  },
                  child: Text("REGISTRATI", style: TextStyle(color: Colors.black))
                )
              )
            ),
          ],
        )
      )
    );
  }

  Container loginFields(BuildContext context) {
    return Container(
      key: Key('login_fields'),          
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 40
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("Effettua l'accesso", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.green[900])),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: mailErrata ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            FormBuilderTextField(
                              name: 'email',
                              onChanged: (val) {
                                setState(() {
                                  mailErrata = !formKey.currentState.fields["email"].validate();
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.mail, color: mailErrata ? Colors.red[800] : Colors.green[800]),
                              ),
                              validator: FormBuilderValidators.email(context, errorText: '')
                            ),
                          ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              FormBuilderTextField(
                                name: 'password',
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(6, 6, 48, 6),
                                  icon: Icon(Icons.lock, color: Colors.green[800])
                                ),
                                obscureText: !isPasswordVisible,
                              ),
                              IconButton(
                                enableFeedback: false,
                                icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.green[800]),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ]
                          ),
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 35),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: MaterialButton(
                            enableFeedback: false,
                            minWidth: MediaQuery.of(context).size.width,
                            height: 60,
                            color: Colors.green[800],
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setInt('logged_in', 1);
                              Navigator.pushAndRemoveUntil(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => Home()
                                ), 
                              ModalRoute.withName("/Home")
                              );
                            },
                            child: Text("ACCEDI", style: TextStyle(color: Colors.white))
                          ),
                        ),
                      )
                    ],
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            ],
          )
        )
      )
    );
  }

  Container registerFields(BuildContext context) {
    return Container(
      key: Key('register_fields'),          
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Registrati", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.green[900])),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FormBuilder(
                    key: formKey2,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: mailErrata ? Colors.red[100] : Colors.green[100],
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              FormBuilderTextField(
                                name: 'name',
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nome",
                                  icon: Icon(Icons.person, color: Colors.green[800]),
                                ),
                              ),
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                FormBuilderTextField(
                                  name: 'surname',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Cognome",
                                    icon: Icon(Icons.person, color: Colors.green[800]),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                FormBuilderTextField(
                                  name: 'email',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Indirizzo mail",
                                    icon: Icon(Icons.mail, color: Colors.green[800]),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                FormBuilderTextField(
                                  name: 'taxCode',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Codice fiscale",
                                    icon: Icon(Icons.tag, color: Colors.green[800]),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                FormBuilderTextField(
                                  name: 'password1',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    icon: Icon(Icons.lock, color: Colors.green[800]),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                FormBuilderTextField(
                                  name: 'passwordConfirmation',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Conferma password",
                                    icon: Icon(Icons.lock, color: Colors.green[800]),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: FormBuilderCheckbox(
                            tristate: false,
                            name: 'accept_terms',
                            initialValue: false,
                            activeColor: Colors.green[800],
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Ho letto ed accetto i ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'termini e condizioni',
                                    style: TextStyle(color: Colors.green[800]),
                                    recognizer: TapGestureRecognizer()..onTap = (){ print("Merda"); },
                                  ),
                                ],
                              ),
                            ),
                            validator: FormBuilderValidators.equal(
                              context,
                              true,
                              errorText: 'Devi accettare i termini e condizioni per poter continuare.',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 35),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: MaterialButton(
                              enableFeedback: false,
                              minWidth: MediaQuery.of(context).size.width,
                              height: 60,
                              color: Colors.green[800],
                              onPressed: (){},
                              child: Text("REGISTRATI", style: TextStyle(color: Colors.white))
                            ),
                          ),
                        )
                      ],
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
              ],
            )
          ),
        )    
    );
  }
}