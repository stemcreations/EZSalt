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
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'EZSalt'),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _scanBarcode = 'Unknown';

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
              onPressed: () async {
                final String ip = await Wifi.ip;
                final String subnet = ip.substring(0, ip.lastIndexOf('.'));
                final int port = 80;
                final stream = NetworkAnalyzer.discover2(subnet, port);
                int found = 0;
                List list = [];
                stream.listen((NetworkAddress addr) {
                  if (addr.exists && addr.ip != '$subnet.1') {
                    found++;
                    list.add(addr.ip);
                  }
                }).onDone(() {print('Found $found devices: ' + '$list');
                });
                },
              child: Text('Discover Network'),
            ),
            RaisedButton(
              child: Text('device setup'),
              onPressed: () {
                Navigator.pushNamed(context, '/deviceSetup');
              },
            ),
            RaisedButton(
              child: Text('Scan Barcode'),
              onPressed: () {
                scanBarcodeNormal();
              },
            ),
            Text(_scanBarcode),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#00FFFFFF', 'Cancel', true, ScanMode.BARCODE);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version.';
    }
    if(!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}


