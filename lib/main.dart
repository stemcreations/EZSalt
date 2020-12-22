import 'package:ez_salt/screens//home.dart';
import 'package:ez_salt/screens//login.dart';
import 'package:ez_salt/screens//profile.dart';
import 'package:ez_salt/screens//register.dart';
import 'package:ez_salt/screens/about.dart';
import 'package:ez_salt/screens/address_setup.dart';
import 'package:ez_salt/screens/device_setup.dart';
import 'package:ez_salt/screens/licenses.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/profile_data.dart';
import 'networking/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final bool isLoggedIn = await checkLoggedInState();

  final MyApp myApp = MyApp(
    initialRoute: isLoggedIn ? '/home' : '/login',
  );
  runApp(myApp);
}

Future<bool> checkLoggedInState() async {
  String authState = await AuthService().checkAuthenticationState();
  if (authState == 'logged in') {
    //Check to see if their profile was setup when they logged in the
    // first time and if not send them to the profile setup page.
    try {
      Map profile = await AuthService().getProfile();
      if (profile == null) {
        AuthService().signOut();
        return false;
      } else if (profile['first_name'] == null) {
        AuthService().signOut();
        return false;
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }

    return true;
  } else {
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
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileData(),
      child: MaterialApp(
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
          '/addressSetup': (context) => AddressSetup(),
        },
      ),
    );
  }
}
