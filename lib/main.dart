import 'package:ez_salt/networking/authentication.dart';
import 'package:ez_salt/screens/local_salt.dart';
import 'package:ez_salt/screens//login.dart';
import 'package:ez_salt/screens//profile.dart';
import 'package:ez_salt/screens//register.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/screens//home.dart';
import 'package:ez_salt/screens/device_setup.dart';
import 'package:flutter/services.dart';
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(MyApp());
}

//TODO this page will be where permissions are asked for as well as the on-boarding slider.

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => Home(),
        '/localSalt': (context) => LocalSaltPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/deviceSetup': (context) => DeviceSetup(),
      },
    );
  }
}
