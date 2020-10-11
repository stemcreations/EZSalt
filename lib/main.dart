import 'package:ez_salt/pages/local_salt.dart';
import 'package:ez_salt/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/pages/home.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'EZSalt'),
        '/login': (context) => LoginPage(),
        '/home': (context) => Home(),
        '/localSalt': (context) => LocalSaltPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
                },
              child: Text('Home'),
            )
          ],
        ),
      ),
    );
  }
}


