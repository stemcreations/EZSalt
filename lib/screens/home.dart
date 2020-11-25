import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_salt/components/common_functions.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  CommonFunctions commonFunctions = CommonFunctions();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map profileData = {};
  int tankLevel = 1;
  String firstName;
  String lastName;
  String email = '';
  bool deliveryEnabled = false;
  bool _isAsyncCall = true;

  bool checkIfNameExists() {
    if (firstName == null || lastName == null) {
      return false;
    } else {
      return true;
    }
  }

  //This function pulls the current tank level readings from firebase and refreshes the state
  Future getTankLevel() async {
    var doubleTankLevel = await _auth.getTankLevel();
    profileData = await _auth.getProfile();
    if (doubleTankLevel.runtimeType == double) {
      tankLevel = commonFunctions.doubleToInt(doubleTankLevel);
    } else if (doubleTankLevel.runtimeType == int) {
      tankLevel = doubleTankLevel;
    }
    if (tankLevel <= 0) {
      tankLevel = 1;
    }
    if (tankLevel > 100) {
      tankLevel = 100;
    }
    setState(() {
      _isAsyncCall = false;
      deliveryEnabled = profileData['delivery_enabled'];
      firstName = profileData['first_name'];
      lastName = profileData['last_name'];
      email = profileData['email'];
    });
  }

  //If user is logged in get the tank level and profile data and if not then go to login screen
  void isLoggedIn() async {
    if (await _auth.checkAuthenticationState() != 'logged in') {
      setState(() {
        _isAsyncCall = false;
      });
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      await getTankLevel();
    }
  }

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  //Navigate to the profile screen when profile screen is popped refresh profile data.
  _returnDataFromProfile(BuildContext context) async {
    await Navigator.pushNamed(context, '/profile');
    profileData = await _auth.getProfile();
    setState(() {
      deliveryEnabled = profileData['delivery_enabled'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName:
          checkIfNameExists() ? Text(firstName + ' ' + lastName) : Text(''),
      accountEmail: Text(email),
      currentAccountPicture: AutoSizeText(
        'EZsalt',
        wrapWords: false,
        style: TextStyle(
            fontFamily: 'EZSalt',
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('Profile'),
          onTap: () {
            if (firstName != null) {
              Navigator.of(context).pop();
              _returnDataFromProfile(context);
            } else {
              showDialog(
                  builder: (context) => AlertDialog(
                        title: Text('Your profile is not setup'),
                        content: Text('Continue to profile setup?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/deviceSetup');
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                  context: context);
            }
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
                            _auth.signOut();
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
    return ModalProgressHUD(
      inAsyncCall: _isAsyncCall,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: drawerItems,
        ),
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryThemeColor,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(
                top: CommonFunctions().getTopNotchSize(context),
                bottom: CommonFunctions().getTopNotchSize(context) / 2),
            child: Text(
              'EZsalt',
              style:
                  TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),
            ),
          ), //App Bar Text and Text style
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10.0, left: 30, right: 30),
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
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 30),
                  child: Container(
                      child: Divider(
                    color: profileScreenTextColor,
                    thickness: 1.5,
                  )),
                ),
                deliveryEnabled
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                        child: ReusableOutlineButton(
                          label: Text(
                            'Schedule Delivery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Open Browser?'),
                                content: Text(
                                    'Are you sure you want to leave the app and open a browser window?'),
                                actions: [
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      launchInWebViewWithJavaScript(
                                        'https://square.site/book/RF2BTQNX9JXWK/ezsalt',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          size: 230,
                          icon: Icon(
                            Icons.developer_board,
                            size: 0,
                          ),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ReusableOutlineButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 0,
                      ),
                      label: Text(
                        'Refresh Tank Level',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isAsyncCall = true;
                        });
                        var result = await _auth
                            .refreshTankLevels()
                            .timeout(Duration(seconds: 7), onTimeout: () {
                          setState(() {
                            _isAsyncCall = false;
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Sensor Reading Failed'),
                              elevation: 5,
                              behavior: SnackBarBehavior.floating,
                            ));
                          });
                        });
                        if (result.runtimeType == double ||
                            result.runtimeType == int) {
                          setState(() {
                            if (result.runtimeType == double) {
                              tankLevel = commonFunctions.doubleToInt(result);
                            } else {
                              tankLevel = result;
                            }
                            _isAsyncCall = false;
                          });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.thumb_up_alt),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Tank Level Refreshed'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            elevation: 5,
                          ));
                        } else {
                          setState(() {
                            _isAsyncCall = false;
                          });
                        }
                        setState(() {
                          _isAsyncCall = false;
                        });
                      },
                      size: 230),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
