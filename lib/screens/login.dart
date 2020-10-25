import 'package:ez_salt/networking/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ez_salt/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

//TODO Need firebase authentication integration for register/forgot password/facebook and google

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool _isAsyncCall = false;
  final formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(content: Text('Username Not Found'),);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
  }

  void _submit() async {
    setState(() {
      _isAsyncCall = true;
    });
    if(email != null && password != null) {
      try {
        await AuthService().signInWithEmailAndPassword(email, password);
        if (AuthService().auth.currentUser.uid != null) {
          setState(() {
            _isAsyncCall = false;
            formKey.currentState.reset();
            Navigator.pushNamed(context, '/home');
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar('Username Not Found');
          setState(() {
            _isAsyncCall = false;
          });
        } else if (e.code == 'wrong-password') {
          showSnackBar('Incorrect Password');
          setState(() {
            _isAsyncCall = false;
          });
          print('Wrong password provided for that user.');
        }
      }
    }else{
      setState(() {
        print('missing value');
        _isAsyncCall = false;
      });
    }
  }

  void resetPasswordDialog(BuildContext context){
    String resetEmail = '';
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Center(
          child: Dialog(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 3,
              child: Container(
                decoration: new BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 20), child: Text('Reset Password', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: CustomTextField(text: 'Email Address', autoFocus: true, keyboardType: TextInputType.emailAddress, onChanged: (String value) { setState(() {
                            resetEmail = value.trim();
                          });},)
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: MaterialButton(
                        minWidth: 120,
                        elevation: 3,
                        color: Colors.grey.shade300,
                        textColor: borderAndTextColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                        onPressed: () async {
                          String result = await AuthService().resetPassword(resetEmail);
                          print(result);
                          Navigator.of(context).pop();
                          },
                        child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
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
                    'EZSalt',
                    style: TextStyle(
                      fontFamily: 'EZSalt',
                      color: borderAndTextColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text){
                      setState(() {
                        email = text.trim();
                      });
                    },
                    text: 'Username',
                    icon: Icon(Icons.person, color: borderAndTextColor,),
                  ), // Sign-in email form field
                  CustomTextField(
                    onChanged: (text){
                      setState(() {
                        password = text.trim();
                      });
                    },
                    obscureText: true,
                    text: 'Password',
                    icon: Icon(Icons.security, color: borderAndTextColor,),
                  ), // Sign-in password field
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: MaterialButton(
                          onPressed: () { resetPasswordDialog(context); },  //TODO need to add function to forgot password
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: borderAndTextColor),
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
                          label: Text('      Login', style: TextStyle(fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.arrow_forward, size: 0, ),
                          onPressed: () async {
                            _submit();
                            // Map data = await AuthService().getProfile();
                            // print(data);
                            //
                          },
                        ),
                        ReusableOutlineButton(
                          size: 110,
                          label: Text('    Register', style: TextStyle(fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.arrow_forward, size: 0,),
                          onPressed: (){
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
                              color: borderAndTextColor,
                            ),
                          ),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(color: borderAndTextColor),
                        ),
                        Expanded(
                          child: Container(
                            child: Divider(
                              indent: 5,
                              endIndent: 70,
                              thickness: 2,
                              color: borderAndTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ReusableOutlineButton(
                    size: 230,
                    icon: Icon(FontAwesomeIcons.google),
                    label: Text('   Continue with Google'),
                    onPressed: (){
                      AuthService().signInWithGoogle().whenComplete(() => Navigator.pushNamed(context, '/home'));
                      },
                  ),
                  //TODO add facebook login integration with firebase and facebook to allow signin with Facebook
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 3),
                  //   child: ReusableOutlineButton(
                  //     size: 230,
                  //     icon: Icon(FontAwesomeIcons.facebook),
                  //     label: Text('   Continue with Facebook'),
                  //     onPressed: (){},
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }
}

