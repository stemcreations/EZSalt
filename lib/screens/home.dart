import 'dart:math' as math;

import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/components/user_interface_adjustments.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map profileData = {};
  int tankLevel = 1;
  double monthlySubscriptionPrice = 3;
  String firstName = '';
  String lastName = '';
  String email = '';

  //This function pulls the current tank level readings from firebase and refreshes the state
  void getTankLevel() async {
    var doubleTankLevel = await AuthService().getTankLevel();
    profileData = await AuthService().getProfile();
    if (doubleTankLevel.runtimeType == double) {
      String stringTankLevel = doubleTankLevel.toString();
      tankLevel = double.parse(stringTankLevel).floor().toInt();
    } else {
      tankLevel = doubleTankLevel;
    }
    if (tankLevel <= 0) {
      tankLevel = 1;
    }
    setState(() {
      firstName = profileData['first_name'];
      lastName = profileData['last_name'];
      email = profileData['email'];
    });
  }

  void isLoggedIn() async {
    if (await AuthService().checkAuthenticationState() != 'logged in') {
      dispose();
    }
    AuthService().getPhoneProviders();
    AuthService().getPhoneProvidersReversed();
  }

  @override
  void initState() {
    isLoggedIn();
    getTankLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(firstName + ' ' + lastName),
      accountEmail: Text(email),
      currentAccountPicture: Text(
        'EZsalt',
        style: TextStyle(
            fontFamily: 'EZSalt',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('Profile'),
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        ListTile(
          title: Text('About'),
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sign Out'),
                    content: Text('Are you sure you want to sign out?'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                            AuthService().signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text('Yes')),
                    ],
                  );
                });
          },
        ),
      ],
    );
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: drawerItems,
        ),
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryThemeColor,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(
                top: UserInterface().getTopNotchSize(context),
                bottom: UserInterface().getTopNotchSize(context) / 2),
            child: Text(
              'EZsalt',
              style:
                  TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),
            ),
          ), //App Bar Text and Text style
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      //Sized box is to make it to where when screen size changes the box will change and keep the graph a circle
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularStepProgressIndicator(
                          startingAngle: math.pi * 5 / 4,
                          arcSize: math.pi * 3 / 2,
                          totalSteps: 100,
                          currentStep: tankLevel,
                          stepSize: 25,
                          selectedColor: Colors.blue,
                          unselectedColor: Colors.grey[300],
                          padding: 0,
                          width: 300,
                          height: 300,
                          selectedStepSize: 25,
                          roundedCap: (_, __) => true,
                          child: Center(
                            child: Text(
                              '$tankLevel%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                color: primaryThemeColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Container(
                    child: Divider(
                  thickness: 2,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ReusableOutlineButton(
                  label: Text('Schedule Delivery'),
                  onPressed: () {
                    launchInWebViewWithJavaScript(
                      'https://square.site/book/RF2BTQNX9JXWK/ezsalt',
                    );
                    //Navigator.pushNamed(context, '/deliveryWeb');
                  },
                  size: 230,
                  icon: Icon(
                    Icons.developer_board,
                    size: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
