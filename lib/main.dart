import 'package:ez_salt/screens/local_salt.dart';
import 'package:ez_salt/screens//login.dart';
import 'package:ez_salt/screens//profile.dart';
import 'package:ez_salt/screens//register.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/screens//home.dart';
import 'package:ez_salt/screens/device_setup.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
