import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_salt/components/common_functions.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/components/profile_data.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool tankReading = true;
  ProfileData model;
  AuthService _auth = AuthService();
  CommonFunctions commonFunctions = CommonFunctions();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    if (doubleTankLevel.runtimeType == double) {
      tankLevel = commonFunctions.doubleToInt(doubleTankLevel);
    } else if (doubleTankLevel.runtimeType == int) {
      tankLevel = doubleTankLevel;
    } else if (doubleTankLevel.runtimeType == String) {
      setState(() {
        tankReading = false;
        _isAsyncCall = false;
      });
      return 'tank reading failed';
    }
    if (tankLevel <= 0) {
      tankLevel = 1;
    }
    if (tankLevel > 100) {
      tankLevel = 100;
    }
    setState(() {
      _isAsyncCall = false;
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

  void updateScreen(BuildContext context) async {
    model = Provider.of<ProfileData>(context);
    await model.getProfileData();
    firstName = model.getFirstName;
    lastName = model.getLastName;
  }

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tankReading == false) {
      setState(() {
        tankReading = true;
      });
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 5,
          content: Text('Tank Reading Failed'),
        ),
      );
    }
    updateScreen(context);
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: checkIfNameExists()
          ? Text(model.getFirstName + ' ' + model.getLastName)
          : Text(''),
      accountEmail: Text(model.getEmail),
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
              Navigator.pushNamed(context, '/profile');
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
                            await _auth.signOut();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: drawerItems,
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryThemeColor,
        centerTitle: true,
        title: SafeArea(
          minimum: EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              'EZsalt',
              style:
                  TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),
            ),
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        _isAsyncCall
                            ? CircularProgressIndicator()
                            : Container(),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 280, maxWidth: 280),
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
                              child: _isAsyncCall
                                  ? SizedBox()
                                  : Text(
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
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
                child: Container(
                    child: Divider(
                  color: profileScreenTextColor,
                  thickness: 1.5,
                )),
              ),
              model.getDeliveryEnabled //deliveryEnabled
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
                            content: Text('Tank Reading Failed'),
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
