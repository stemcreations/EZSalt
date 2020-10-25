import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isAsyncCall = false;
  String email;
  String password;
  String confirmedPassword;
  bool passwordsMatch;
  IconData icon;
  Color iconColor;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
  }



  bool assertNoNullFields(){
    if(email != null && passwordsMatch != false
    ){
      return true;
    }else {
      return false;
    }
  }

  void checkPasswordMatch(){
    if(password == confirmedPassword){
      setState(() {
        icon = Icons.check;
        iconColor = Colors.green;
        passwordsMatch = true;
      });
    }else{
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'EZSalt',
                      style: TextStyle(
                        fontFamily: 'EZSalt',
                        color: borderAndTextColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  CustomTextField(text: 'Email Address', onChanged: (text) => email = text.trim(), keyboardType: TextInputType.emailAddress,), //email / username
                  CustomTextField(text: 'Password', obscureText: true, onChanged: (text) => password = text.trim(), icon: Icon(icon, color: iconColor,),), //password
                  CustomTextField(text: 'Confirm Password', obscureText: true, onChanged: (text){
                    confirmedPassword = text;
                    checkPasswordMatch();
                    },
                    icon: Icon(icon, color: iconColor,),
                  ), //re-enter password
                  // Dropdown menu for phone providers.
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        if(assertNoNullFields()) {
                          setState(() {
                            _isAsyncCall = true;
                          });
                          await AuthService().createUserWithEmailAndPassword(
                              email,
                              password,
                          );
                          formKey.currentState.reset();
                          setState(() {
                            _isAsyncCall = false;
                          });
                          Navigator.pushNamed(context, '/deviceSetup');
                          }else{
                          showSnackBar('Missing Fields');
                          }
                        },
                      child: Text('Submit', style: TextStyle(color: borderAndTextColor),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.grey.shade300,
                      elevation: 3,
                    ),
                  ), //Submit button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
