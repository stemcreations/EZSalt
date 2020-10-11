import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

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
                  color: Colors.blue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 30,
                ),
              ),
              CustomTextField(
                text: 'Username',
                icon: Icon(Icons.person, color: Colors.blue,),
              ),
              SizedBox(
                  height: 10
              ),
              CustomTextField(
                text: 'Password',
                icon: Icon(Icons.security, color: Colors.blue,),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: MaterialButton(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
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
                        //Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 70,
                endIndent: 70,
                thickness: 2,
                color: Colors.blue,
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
              ReusableOutlineButton(
                size: 230,
                icon: Icon(FontAwesomeIcons.apple),
                label: Text('   Continue with Apple'),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


