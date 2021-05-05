import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class LoginRegisterOld extends StatefulWidget {
  LoginRegisterOld({Key key}) : super(key: key);

  @override
  _LoginRegisterOldState createState() => _LoginRegisterOldState();
}

class _LoginRegisterOldState extends State<LoginRegisterOld> {


  int pagina = 0;
  int prevState = 0;

  Future<bool> _interceptBackKey() {
    setState(() {
          pagina = prevState;
    });
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
            )
          ],
        )
        )
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
                width: MediaQuery.of(context)?.size.width * 0.8,
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
                width: MediaQuery.of(context)?.size.width * 0.8,
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
              Padding(
                child: Divider(
                  height: 30,
                  thickness: 2,
                ),
                padding: EdgeInsets.symmetric(horizontal: 150)
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Oppure, effettua il login con"),
                      ], 
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      )
                    )
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: ClipOval(
                        child: Material(
                          color: Colors.grey,
                          child: InkWell(
                            enableFeedback: false,
                            splashColor: Colors.green[800],
                            child: SizedBox(width: 50, height: 50, child: Icon(FontAwesomeIcons.google, color: Colors.white)),
                            onTap: (){}
                          )
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: ClipOval(
                      child: Material(
                        color: Colors.grey,
                        child: InkWell(
                          enableFeedback: false,
                          splashColor: Colors.green[800],
                          child: SizedBox(width: 50, height: 50, child: Icon(FontAwesomeIcons.github, color: Colors.white)),
                          onTap: (){}
                        )
                      )
                    )
                    )
                  ]
                )
              )
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(30)
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mail",
                  icon: Icon(Icons.mail, color: Colors.green[800]),
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 35),
                width: MediaQuery.of(context)?.size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    enableFeedback: false,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: Colors.green[800],
                    onPressed: (){},
                    child: Text("ACCEDI", style: TextStyle(color: Colors.white))
                  )
                )
              ),
            InkWell(
              enableFeedback: false,
              onTap: (){
                setState(() {
                  prevState = 0;
                  pagina = 2;                       
                });
              },
              child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Non hai ancora un account? "),
                        TextSpan(text: "Registrati ora", style: TextStyle(fontWeight: FontWeight.bold))
                      ], 
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      )
                    )
                  )
            )
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
        padding: EdgeInsets.symmetric(
          vertical: 40
        ),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text("Registrati", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.green[900])),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(30)
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Mail",
                  icon: Icon(Icons.mail, color: Colors.green[800]),
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: Icon(Icons.lock, color: Colors.green[800]),
                    suffixIcon: Icon(Icons.visibility, color: Colors.green[800])
                  ),
                )
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 35),
                width: MediaQuery.of(context)?.size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MaterialButton(
                    enableFeedback: false,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: Colors.green[800],
                    onPressed: (){},
                    child: Text("ACCEDI", style: TextStyle(color: Colors.white))
                  )
                )
              ),
            InkWell(
              enableFeedback: false,
              onTap: (){
                setState(() {
                  prevState = 0;
                  pagina = 1;                       
                });
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Hai già un account? "),
                    TextSpan(text: "Accedi", style: TextStyle(fontWeight: FontWeight.bold))
                  ], 
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  )
                )
              )
            )
          ],
        )
        )
      )
    );
  }
}