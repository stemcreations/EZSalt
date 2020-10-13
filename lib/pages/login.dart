import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

//TODO Need firebase authentication integration for login/register/forgot password/facebook and google

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'EZSalt',
                style: TextStyle(
                  fontFamily: 'EZSalt',
                  color: Colors.indigo,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                text: 'Username',
                icon: Icon(Icons.person, color: Colors.indigo,),
              ),
              SizedBox(
                  height: 10
              ),
              CustomTextField(
                text: 'Password',
                icon: Icon(Icons.security, color: Colors.indigo,),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: MaterialButton(
                      onPressed: () {  },  //TODO need to add function to forgot password
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ),
                ],
              ),
              // Flexible(
              //   child: SizedBox(
              //     height: 40,
              //   ),
              // ),
              SizedBox(
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableOutlineButton(
                      size: 110,
                      label: Text('      Login', style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.arrow_forward, size: 0,),
                      onPressed: (){
                        Navigator.pushNamed(context, '/home');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      child: Divider(
                        indent: 70,
                        endIndent: 5,
                        thickness: 2,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(color: Colors.indigo),
                  ),
                  Expanded(
                    child: Container(
                      child: Divider(
                        indent: 5,
                        endIndent: 70,
                        thickness: 2,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
              ReusableOutlineButton(
                size: 230,
                icon: Icon(FontAwesomeIcons.google),
                label: Text('   Continue with Google'),
                onPressed: (){},
              ),
              ReusableOutlineButton(
                size: 230,
                icon: Icon(FontAwesomeIcons.facebook),
                label: Text('   Continue with Facebook'),
                onPressed: (){},
              ),
              // ReusableOutlineButton(
              //   size: 230,
              //   icon: Icon(FontAwesomeIcons.apple),
              //   label: Text('   Continue with Apple'),
              //   onPressed: (){},
              // ),
            ],
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


