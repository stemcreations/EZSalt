import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

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
    content: Text('Username Not Found'),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget checkPlatform() {
    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 3, top: 10),
        child: ReusableOutlineButton(
          size: 230,
          icon: Icon(FontAwesomeIcons.apple),
          label: Text('Continue with Apple'),
          onPressed: () async {
            AuthService()
                .signInWithApple(scopes: [Scope.email, Scope.fullName]);
          },
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

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
    if (email != null && password != null && password != '' && email != '') {
      result = await AuthService().signInWithEmailAndPassword(email, password);
      if (result == 'user authenticated') {
        setState(() {
          _isAsyncCall = false;
          formKey.currentState.reset();
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
        child: ModalProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: SingleChildScrollView(
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
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      setState(() {
                        email = text.trim();
                      });
                    },
                    text: 'Username',
                    icon: Icon(
                      Icons.person,
                      color: primaryThemeColor,
                    ),
                  ), // Sign-in email form field
                  CustomTextField(
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
                        padding: const EdgeInsets.only(left: 30),
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
                  SizedBox(
                    width: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                        ReusableOutlineButton(
                          size: 110,
                          label: Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                  ReusableOutlineButton(
                    size: 230,
                    icon: Icon(FontAwesomeIcons.google),
                    label: Text('Continue with Google'),
                    onPressed: () async {
                      String result = await AuthService().signInWithGoogle();
                      if (result == 'new user created') {
                        Navigator.pushReplacementNamed(context, '/deviceSetup');
                      } else if (result == 'signInWithGoogle succeeded') {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  ),
                  checkPlatform(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 3),
                    child: ReusableOutlineButton(
                      label: Text('Buy Sensor'),
                      onPressed: () {
                        launchInWebViewWithJavaScript(
                          'https://www.ezsalt.xyz/',
                        );
                        //Navigator.pushNamed(context, '/orderSensorWeb');
                      },
                      size: 230,
                      icon: Icon(Icons.developer_board),
                    ),
                  ),
                ],
              ),
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
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
