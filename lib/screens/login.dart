import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO launch in browser and notify user that they are leaving the app

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool _isAsyncCall = false;
  final formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Email Not Found'),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _submit() async {
    String result;
    setState(() {
      _isAsyncCall = true;
    });

    // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    if (email != null && password != null && password != '' && email != '') {
      result = await AuthService().signInWithEmailAndPassword(email, password);
      Map profile = await AuthService().getProfile();
      if (profile == null) {
        showSnackBar(result);
        setState(() {
          _isAsyncCall = false;
        });
      } else if (result == 'user authenticated' && profile['first_name'] != null) {
        setState(() {
          _isAsyncCall = false;
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else if (result == 'User not found') {
        showSnackBar(result);
        setState(() {
          _isAsyncCall = false;
        });
      } else if (result == 'Incorrect password') {
        showSnackBar(result);
        setState(() {
          _isAsyncCall = false;
        });
      } else if (result == 'new user created' || profile == null) {
        Navigator.pushReplacementNamed(context, '/deviceSetup');
        _isAsyncCall = false;
      } else if (profile['first_name'] == null) {
        Navigator.pushReplacementNamed(context, '/deviceSetup');
        _isAsyncCall = false;
      } else {
        showSnackBar(result);
        setState(() {
          _isAsyncCall = false;
        });
      }
    } else {
      showSnackBar('Missing Value');
      setState(() {
        print('missing value');
        _isAsyncCall = false;
      });
    }
    setState(() {
      _isAsyncCall = false;
    });
  }

  void resetPasswordDialog(BuildContext context) {
    String resetEmail = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontSize: 20, color: primaryThemeColor),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: CustomTextField(
                                text: 'Email Address',
                                autoFocus: true,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (String value) {
                                  setState(() {
                                    resetEmail = value.trim();
                                  });
                                },
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: MaterialButton(
                          minWidth: 120,
                          elevation: 3,
                          color: Colors.grey.shade300,
                          textColor: primaryThemeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          onPressed: () async {
                            String result =
                                await AuthService().resetPassword(resetEmail);
                            print(result);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: Center(
        child: _isAsyncCall
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'EZsalt',
                        style: TextStyle(
                          fontFamily: 'EZSalt',
                          color: primaryThemeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        //labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (text) {
                          setState(() {
                            email = text.trim();
                          });
                        },
                        text: 'Email',
                        icon: Icon(
                          Icons.person,
                          color: primaryThemeColor,
                        ),
                      ), // Sign-in email form field
                      CustomTextField(
                        textCapitalization: TextCapitalization.none,
                        onChanged: (text) {
                          setState(() {
                            password = text.trim();
                          });
                        },
                        obscureText: true,
                        text: 'Password',
                        icon: Icon(
                          Icons.security,
                          color: primaryThemeColor,
                        ),
                      ), // Sign-in password field
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, bottom: 30.0),
                            child: MaterialButton(
                              onPressed: () {
                                resetPasswordDialog(context);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: primaryThemeColor),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Login button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableOutlineButton(
                            size: 110,
                            label: Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 0,
                            ),
                            onPressed: () async {
                              _submit();
                            },
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                child: Divider(
                                  indent: 70,
                                  endIndent: 5,
                                  thickness: 2,
                                  color: primaryThemeColor,
                                ),
                              ),
                            ),
                            Text(
                              'OR',
                              style: TextStyle(color: primaryThemeColor),
                            ),
                            Expanded(
                              child: Container(
                                child: Divider(
                                  indent: 5,
                                  endIndent: 70,
                                  thickness: 2,
                                  color: primaryThemeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Create Account Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          ReusableOutlineButton(
                            size: 150,
                            label: Text(
                              'Create Account',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 0,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/deviceSetup');
                            },
                          )

                        ],
                      ),


                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10, bottom: 3),
                      //   child: ReusableOutlineButton(
                      //     label: Text('Buy Sensor'),
                      //     onPressed: () {
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //           title: Text('Open Browser?'),
                      //           content: Text(
                      //               'Are you sure you want to leave the app and open a browser window?'),
                      //           actions: [
                      //             TextButton(
                      //               child: Text('No'),
                      //               onPressed: () => Navigator.pop(context),
                      //             ),
                      //             TextButton(
                      //                 child: Text('Yes'),
                      //                 onPressed: () {
                      //                   Navigator.pop(context);
                      //                   launchInWebViewWithJavaScript(
                      //                     'https://www.ezsalt.xyz/',
                      //                   );
                      //                 }),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //     size: 230,
                      //     icon: Icon(Icons.developer_board),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
