import 'package:ParkPlus/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ParkPlus());
}

class ParkPlus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkPlus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.green[800],
        scaffoldBackgroundColor: Color(0xffF8F8F8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}