import 'package:ez_salt/screens/about.dart';
import 'package:ez_salt/screens/licenses.dart';
import 'package:ez_salt/screens//login.dart';
import 'package:ez_salt/screens//profile.dart';
import 'package:ez_salt/screens//register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/screens//home.dart';
import 'package:ez_salt/screens/device_setup.dart';
import 'package:flutter/services.dart';
import 'networking/authentication.dart';

//TODO Set minimum iOS deployment target to 10 and set Swift version to 5.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final bool isLogged = await checkLoggedInState();
  final MyApp myApp = MyApp(
    initialRoute: isLogged ? '/home' : '/login',
  );
  runApp(myApp);
}

Future<bool> checkLoggedInState () async {
  String authState = await AuthService().checkAuthenticationState();
  if(authState == 'logged in'){
    return true;
  }else{
    return false;
  }
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
  MyApp({this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => Home(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/deviceSetup': (context) => DeviceSetup(),
        '/licenses': (context) => Licenses(),
        '/about': (context) => About(),
      },
    );
  }
}


