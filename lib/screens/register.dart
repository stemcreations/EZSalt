import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String result;
  bool _isAsyncCall = false;
  String email;
  String password;
  String confirmedPassword;
  bool passwordsMatch;
  IconData icon;
  Color iconColor;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool assertNoNullFields() {
    if (email != null &&
        passwordsMatch != false &&
        email != '' &&
        password != '') {
      print('true');
      return true;
    } else {
      return false;
    }
  }

  void checkPasswordMatch() {
    if (password == confirmedPassword) {
      setState(() {
        icon = Icons.check;
        iconColor = Colors.green;
        passwordsMatch = true;
      });
    } else {
      setState(() {
        icon = Icons.clear;
        iconColor = Colors.red;
        passwordsMatch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'EZsalt',
                          style: TextStyle(
                            fontFamily: 'EZSalt',
                            color: primaryThemeColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      CustomTextField(
                        text: 'Email Address',
                        onChanged: (text) => email = text.trim(),
                        keyboardType: TextInputType.emailAddress,
                      ), //email / username
                      CustomTextField(
                        textCapitalization: TextCapitalization.none,
                        text: 'Password',
                        obscureText: true,
                        onChanged: (text) => password = text.trim(),
                        icon: Icon(
                          icon,
                          color: iconColor,
                        ),
                      ), //password
                      CustomTextField(
                        textCapitalization: TextCapitalization.none,
                        text: 'Confirm Password',
                        obscureText: true,
                        onChanged: (text) {
                          confirmedPassword = text;
                          checkPasswordMatch();
                        },
                        icon: Icon(
                          icon,
                          color: iconColor,
                        ),
                      ), //re-enter password
                      // Dropdown menu for phone providers.
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                        child: ReusableOutlineButton(
                          onPressed: () async {
                            if (email != null &&
                                password != null &&
                                password != '' &&
                                passwordsMatch != null &&
                                passwordsMatch != false &&
                                confirmedPassword != '' &&
                                confirmedPassword != null) {
                              setState(() {
                                _isAsyncCall = true;
                              });
                              result = await AuthService()
                                  .createUserWithEmailAndPassword(
                                email,
                                password,
                              );
                              print(result);
                              if (result == 'Account Created') {
                                await AuthService().profileAndDeviceSetup(
                                    newProfileSetupData[0],
                                    newProfileSetupData[1],
                                    newProfileSetupData[2],
                                    newProfileSetupData[3],
                                    newProfileSetupData[4],
                                    newProfileSetupData[5],
                                    newProfileSetupData[6],
                                    newProfileSetupData[7],
                                    newProfileSetupData[8],
                                    newProfileSetupData[9],
                                    newProfileSetupData[10]);
                                setState(() {
                                  _isAsyncCall = false;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } else {
                                setState(() {
                                  _isAsyncCall = false;
                                });
                                showSnackBar(result);
                              }
                            } else {
                              setState(() {
                                _isAsyncCall = false;
                              });
                              showSnackBar('Missing Fields');
                            }
                          },
                          size: 110,
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 0,
                          ),
                          label: Text(
                            'Submit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), //Submit button
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
